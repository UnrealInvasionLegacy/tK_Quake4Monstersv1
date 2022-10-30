class Q4Grunt extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;
var() config bool bCanFrenzy;
var() config int FrenzyHealthBoost;
var() config float FrenzyDamageMultiplier;
var() config float FrenzyChance;
var() bool bFrenzy;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Other.Class == ProjectileClass)
        {
            Projectile(Other).Damage = ProjectileDamage;
        }
    }

    Super(Monster).GainedChild(Other);
}

function RangedAttack(Actor A)
{
	local float Dist;

	if ( bShotAnim )
	{
		return;
	}

	Dist = VSize(A.Location - Location);
	Target = A;

	if(Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction(MeleeAnims[Rand(4)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
	}
	else if(Level.TimeSeconds - LastRangedAttack > RangedAttackInterval)
	{
		SetAnimAction(RangedAttackAnims[Rand(4)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastRangedAttack = Level.TimeSeconds;
		bShotAnim = true;
	}
}

function FireProjectile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('muzzle_flash');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

simulated function BurnAway()
{
	if(bUseBurnAwayEffect && BurnFX != None)
	{
		Skins[0] = BurnFX;
		Skins[1] = BurnFX;
		Skins[2] = BurnFX;
		bBurning = true;
	}

	Super.BurnAway();
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    local int actualDamage;
    local Controller Killer;

    if ( damagetype == None )
    {
        if ( InstigatedBy != None )
            warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
        DamageType = class'DamageType';
    }

    if ( Role < ROLE_Authority )
    {
        log(self$" client damage type "$damageType$" by "$instigatedBy);
        return;
    }

    if ( Health <= 0 )
        return;

    if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
        instigatedBy = DelayedDamageInstigatorController.Pawn;

    if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
        SetMovementPhysics();
    if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
        momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
    if ( instigatedBy == self )
        momentum *= 0.6;
    momentum = momentum/Mass;

    if (Weapon != None)
        Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if (DrivenVehicle != None)
            DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
        Damage *= 2;
    actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
    if( DamageType.default.bArmorStops && (actualDamage > 0) )
        actualDamage = ShieldAbsorb(actualDamage);

    //everytime a successful hit has chance to frenzy
    if(!bFrenzy && bCanFrenzy && fRand() < FrenzyChance)
    {
		SetAnimAction('Anger02');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastRangedAttack = Level.TimeSeconds;
		bShotAnim = true;
		bFrenzy = true;
		MeleeDamage *= FrenzyDamageMultiplier;
		Health += FrenzyHealthBoost;
	}

    Health -= actualDamage;
    if ( HitLocation == vect(0,0,0) )
        HitLocation = Location;

    PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);
    if ( Health <= 0 )
    {
        // pawn died
        if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
            Killer = LastHitBy;
        else if ( instigatedBy != None )
            Killer = instigatedBy.GetKillerController();
        if ( Killer == None && DamageType.Default.bDelayedDamage )
            Killer = DelayedDamageInstigatorController;
        if ( bPhysicsAnimUpdate )
            TearOffMomentum = momentum;
        Died(Killer, damageType, HitLocation);
    }
    else
    {
        AddVelocity( momentum );
        if ( Controller != None )
            Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
        if ( instigatedBy != None && instigatedBy != self )
            LastHitBy = instigatedBy.Controller;
    }
    MakeNoise(1.0);
}

defaultproperties
{
     ProjectileDamage=6
     bCanFrenzy=True
     FrenzyHealthBoost=75
     FrenzyDamageMultiplier=1.500000
     FrenzyChance=0.250000
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee02"
     MeleeAnims(2)="Melee03"
     MeleeAnims(3)="Melee04"
     HitAnims(0)="Pain02"
     HitAnims(1)="Pain03"
     HitAnims(2)="Pain04"
     HitAnims(3)="Pain02"
     DeathAnims(0)="Pain01"
     DeathAnims(1)="Pain01"
     DeathAnims(2)="Pain01"
     DeathAnims(3)="Pain01"
     RangedAttackAnims(0)="RangedAttack"
     RangedAttackAnims(1)="RangedAttack"
     RangedAttackAnims(2)="RangedAttack"
     RangedAttackAnims(3)="RangedAttack"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.grunt.breath01'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.grunt.breath02'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.grunt.breath03'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.grunt.breath04'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.Berserker.run01'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.Berserker.run02'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.Berserker.run03'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.Berserker.run04'
     RangedAttackInterval=8.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=20
     NewHealth=150
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Grunt_Proj'
     HitSound(0)=Sound'tk_Quake4Monstersv1.grunt.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.grunt.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.grunt.pain3'
     HitSound(3)=Sound'tk_Quake4Monstersv1.grunt.pain4'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.grunt.Die01'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.grunt.Die02'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.grunt.Die01'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.grunt.Die02'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.grunt.growl01'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.grunt.growl02'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.grunt.growl01'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.grunt.growl02'
     FireSound=Sound'tk_Quake4Monstersv1.grunt.blaster03'
     ScoringValue=8
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeL"
     WallDodgeAnims(2)="DodgeR"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Run"
     FireHeavyBurstAnim="Run"
     FireRifleRapidAnim="Run"
     FireRifleBurstAnim="Run"
     MeleeRange=65.000000
     GroundSpeed=400.000000
     Health=150
     MovementAnims(0)="Run"
     MovementAnims(1)="Run"
     MovementAnims(2)="Run"
     MovementAnims(3)="Run"
     TurnLeftAnim="Run"
     TurnRightAnim="Run"
     SwimAnims(0)="Run"
     SwimAnims(1)="Run"
     SwimAnims(2)="Run"
     SwimAnims(3)="Run"
     CrouchAnims(0)="Run"
     CrouchAnims(1)="Run"
     CrouchAnims(2)="Run"
     CrouchAnims(3)="Run"
     WalkAnims(0)="Run"
     WalkAnims(1)="Run"
     WalkAnims(2)="Run"
     WalkAnims(3)="Run"
     AirAnims(0)="Run"
     AirAnims(1)="Run"
     AirAnims(2)="Run"
     AirAnims(3)="Run"
     TakeoffAnims(0)="Run"
     TakeoffAnims(1)="Run"
     TakeoffAnims(2)="Run"
     TakeoffAnims(3)="Run"
     LandAnims(0)="Run"
     LandAnims(1)="Run"
     LandAnims(2)="Run"
     LandAnims(3)="Run"
     DoubleJumpAnims(0)="Run"
     DoubleJumpAnims(1)="Run"
     DoubleJumpAnims(2)="Run"
     DoubleJumpAnims(3)="Run"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Run"
     TakeoffStillAnim="Run"
     CrouchTurnRightAnim="Run"
     CrouchTurnLeftAnim="Run"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Grunt_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Grunt_skin01'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.Grunt_skin02'
     Skins(2)=Texture'tk_Quake4Monstersv1.MonsterTextures.Grunt_skin03'
     CollisionRadius=35.000000
     CollisionHeight=50.000000
}

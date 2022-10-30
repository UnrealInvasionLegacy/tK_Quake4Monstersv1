//=============================================================================
// Q4Gladiator.
//=============================================================================
class Q4Gladiator extends Quake4Monster config(Quake4Monsters);

var() config int BlasterDamage;
var() config int RailgunDamage;
var() class<Projectile> BlasterClass;
//var() bool bShieldActive;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

	SetBoneScale(6, 0.0, 'shield_jt');
}

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Other.Class == ProjectileClass)
        {
            Projectile(Other).Damage = RailgunDamage;
        }
        else if(Other.Class == BlasterClass)
        {
            Projectile(Other).Damage = BlasterDamage;
        }
    }

    Super(Monster).GainedChild(Other);
}

/*simulated function DeactivateShield()
{
	bShieldActive = false;
	SetBoneScale(8,0,'shield_jt');
}

simulated function ActivateShield()
{
	bShieldActive = true;
	SetOverlayMaterial( None, 0.0f, true);
	SetBoneScale(8,1,'shield_jt');
}*/

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

//blaster
function FireProjectile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('blaster');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(BlasterClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,10));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

//railgun
function RangedAttackBig()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('railgun');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Gladiator.railgun_blast',SLOT_Interact);
		}
	}
}

simulated function BurnAway()
{
	//Spawn(class'GreenExplode',self,,location,rotation);
	if(bUseBurnAwayEffect && BurnFX != None)
	{
		Skins[0] = BurnFX;
		Skins[1] = BurnFX;
		Skins[2] = BurnFX;
		Skins[3] = InvisMat;
		bBurning = true;
	}

	Super.BurnAway();
}

/*function int CheckShield( Vector HitLocation, int FinalDamage)
{
    local Vector HitDir;
    local Vector FaceDir;

    FaceDir = Vector(Rotation);
    HitDir = Normal(Location - HitLocation + Vect(0,0,8));

    if ( FaceDir dot HitDir < -0.37 )
    {
		FinalDamage = 0;
    }

    return FinalDamage;
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
    {
        actualDamage = ShieldAbsorb(actualDamage);
	}

	if(bShieldActive)
	{
		actualDamage = CheckShield(HitLocation, actualDamage);
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

simulated function SetOverlayMaterial( Material mat, float time, bool bOverride )
{
	if(!bShieldActive)
	{
		Super.SetOverlayMaterial(mat, time, bOverride);
	}
}
*/

defaultproperties
{
     BlasterDamage=40
     RailgunDamage=90
     BlasterClass=Class'tk_Quake4Monstersv1.Q4Gladiator_Blaster_Proj'
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee02"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee02"
     HitAnims(0)="Pain02"
     HitAnims(1)="Pain02"
     HitAnims(2)="Pain02"
     HitAnims(3)="Pain02"
     DeathAnims(0)="Pain01"
     DeathAnims(1)="Pain01"
     DeathAnims(2)="Pain01"
     DeathAnims(3)="Pain01"
     RangedAttackAnims(0)="Blaster01"
     RangedAttackAnims(1)="BigShoot01"
     RangedAttackAnims(2)="BigShoot03"
     RangedAttackAnims(3)="BigShoot01"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Gladiator.breath01'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Gladiator.breath02'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Gladiator.breath03'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Gladiator.breath01'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.Berserker.run01'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.Berserker.run02'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.Berserker.run03'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.Berserker.run04'
     RangedAttackInterval=3.500000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=60
     NewHealth=550
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Gladiator_Proj'
     HitSound(0)=Sound'tk_Quake4Monstersv1.Gladiator.pain'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Gladiator.pain'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Gladiator.pain'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Gladiator.pain'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Gladiator.Death'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Gladiator.Death'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Gladiator.Death'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Gladiator.Death'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Gladiator.alert'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Gladiator.alert'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Gladiator.alert'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Gladiator.alert'
     FireSound=Sound'tk_Quake4Monstersv1.Gladiator.rapidfire_01'
     ScoringValue=15
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeL"
     WallDodgeAnims(2)="DodgeR"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle02"
     IdleRifleAnim="Idle02"
     FireHeavyRapidAnim="Walk01"
     FireHeavyBurstAnim="Walk01"
     FireRifleRapidAnim="Walk01"
     FireRifleBurstAnim="Walk01"
     bCanJump=False
     MeleeRange=85.000000
     GroundSpeed=300.000000
     Health=550
     MovementAnims(0)="Walk01"
     MovementAnims(1)="Walk01"
     MovementAnims(2)="Walk01"
     MovementAnims(3)="Walk01"
     TurnLeftAnim="Walk01"
     TurnRightAnim="Walk01"
     SwimAnims(0)="Walk01"
     SwimAnims(1)="Walk01"
     SwimAnims(2)="Walk01"
     SwimAnims(3)="Walk01"
     CrouchAnims(0)="Walk01"
     CrouchAnims(1)="Walk01"
     CrouchAnims(2)="Walk01"
     CrouchAnims(3)="Walk01"
     WalkAnims(0)="Walk01"
     WalkAnims(1)="Walk01"
     WalkAnims(2)="Walk01"
     WalkAnims(3)="Walk01"
     AirAnims(0)="Walk01"
     AirAnims(1)="Walk01"
     AirAnims(2)="Walk01"
     AirAnims(3)="Walk01"
     TakeoffAnims(0)="Walk01"
     TakeoffAnims(1)="Walk01"
     TakeoffAnims(2)="Walk01"
     TakeoffAnims(3)="Walk01"
     LandAnims(0)="Walk01"
     LandAnims(1)="Walk01"
     LandAnims(2)="Walk01"
     LandAnims(3)="Walk01"
     DoubleJumpAnims(0)="Walk01"
     DoubleJumpAnims(1)="Walk01"
     DoubleJumpAnims(2)="Walk01"
     DoubleJumpAnims(3)="Walk01"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Walk01"
     TakeoffStillAnim="Walk01"
     CrouchTurnRightAnim="Walk01"
     CrouchTurnLeftAnim="Walk01"
     IdleCrouchAnim="Idle02"
     IdleSwimAnim="Idle02"
     IdleWeaponAnim="Idle02"
     IdleRestAnim="Idle02"
     IdleChatAnim="Idle02"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Gladiator_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Gladiator_skin02'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.Gladiator_skin01'
     Skins(2)=Texture'tk_Quake4Monstersv1.MonsterTextures.Gladiator_skin03'
     Skins(3)=Shader'tk_Quake4Monstersv1.MonsterTextures.InvisMat'
     CollisionRadius=35.000000
     CollisionHeight=70.000000
}

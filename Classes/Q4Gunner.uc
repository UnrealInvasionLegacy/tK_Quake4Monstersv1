class Q4Gunner extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;
var() config int GrenadeDamage;
var() config float GrenadeIntervalTime;
var() float LastGrenadeTime;
var() class<Projectile> GrenadeClass;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Other.Class == ProjectileClass)
        {
            Projectile(Other).Damage = ProjectileDamage;
        }
        else if(Other.Class == GrenadeClass)
        {
            Projectile(Other).Damage = GrenadeDamage;
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
	else if(Level.TimeSeconds - LastGrenadeTime > GrenadeIntervalTime)
	{
		SetAnimAction('Attack02');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastGrenadeTime = Level.TimeSeconds;
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
		BoneLocation = GetBoneCoords('Muzzle');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

function FireGrenade()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('Muzzle');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(GrenadeClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Gunner.grenadelaunch',SLOT_Interact);
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
		Skins[3] = BurnFX;
		Skins[4] = BurnFX;
		bBurning = true;
	}

	Super.BurnAway();
}

defaultproperties
{
     ProjectileDamage=12
     GrenadeDamage=60
     GrenadeIntervalTime=7.000000
     GrenadeClass=Class'tk_Quake4Monstersv1.Q4Gunner_Grenade'
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee02"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee02"
     HitAnims(0)="Pain01"
     HitAnims(1)="Pain03"
     HitAnims(2)="Pain04"
     HitAnims(3)="Pain01"
     DeathAnims(0)="Pain02"
     DeathAnims(1)="Pain02"
     DeathAnims(2)="Pain02"
     DeathAnims(3)="Pain02"
     RangedAttackAnims(0)="Attack01"
     RangedAttackAnims(1)="Attack03"
     RangedAttackAnims(2)="Attack01"
     RangedAttackAnims(3)="Attack03"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Gunner.growl1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Gunner.growl2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Gunner.growl3'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Gunner.growl4'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.Gunner.run_01'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.Gunner.run_02'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.Gunner.run_03'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.Gunner.run_04'
     RangedAttackInterval=3.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=25
     NewHealth=300
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Gunner_Proj'
     bCanDodge=False
     HitSound(0)=Sound'tk_Quake4Monstersv1.Gunner.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Gunner.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Gunner.pain3'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Gunner.pain4'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Gunner.die1'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Gunner.die2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Gunner.die3'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Gunner.die4'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Gunner.sight1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Gunner.sight5'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Gunner.sight10'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Gunner.sight12'
     FireSound=Sound'tk_Quake4Monstersv1.Gunner.nailgun1'
     ScoringValue=8
     WallDodgeAnims(0)="Walk01"
     WallDodgeAnims(1)="Walk01"
     WallDodgeAnims(2)="Walk01"
     WallDodgeAnims(3)="Walk01"
     IdleHeavyAnim="Idle01"
     IdleRifleAnim="Idle01"
     FireHeavyRapidAnim="Walk01"
     FireHeavyBurstAnim="Walk01"
     FireRifleRapidAnim="Walk01"
     FireRifleBurstAnim="Walk01"
     bCanJump=False
     MeleeRange=70.000000
     GroundSpeed=400.000000
     Health=300
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
     DodgeAnims(0)="Walk01"
     DodgeAnims(1)="Walk01"
     DodgeAnims(2)="Walk01"
     DodgeAnims(3)="Walk01"
     AirStillAnim="Walk01"
     TakeoffStillAnim="Walk01"
     CrouchTurnRightAnim="Walk01"
     CrouchTurnLeftAnim="Walk01"
     IdleCrouchAnim="Idle01"
     IdleSwimAnim="Idle01"
     IdleWeaponAnim="Idle01"
     IdleRestAnim="Idle01"
     IdleChatAnim="Idle01"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Gunner_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Gunner_skin03'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.Gunner_skin01'
     Skins(2)=Texture'tk_Quake4Monstersv1.MonsterTextures.Gunner_skin02'
     Skins(3)=Texture'tk_Quake4Monstersv1.MonsterTextures.Gunner_skin04'
     Skins(4)=Texture'tk_Quake4Monstersv1.MonsterTextures.Gunner_skin05'
     CollisionRadius=30.000000
     CollisionHeight=55.000000
}

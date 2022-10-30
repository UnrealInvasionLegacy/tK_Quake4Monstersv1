class Q4Harvester extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;
var() config int MissileDamage;
var() config bool bMissileCanLock;
var() class<Projectile> MissileClass;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Other.Class == ProjectileClass)
        {
            Projectile(Other).Damage = ProjectileDamage;
        }
        else if(Q4Harvester_Missile(Other) != None)
        {
			Q4Harvester_Missile(Other).Damage = MissileDamage;
			Q4Harvester_Missile(Other).bMissileCanLock = bMissileCanLock;
			if(Target != None)
			{
				Q4Harvester_Missile(Other).Seeking = Target;
			}
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

	Target = A;
	Dist = VSize(A.Location - Location);

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

function FireBoth()
{
	FireProjectileLeft();
	FireProjectile();
}

function FireProjectileLeft()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('lft_muzzle_flash');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

function FireProjectile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('rt_muzzle_flash');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

function FireMissile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('rt_muzzle_flash');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(MissileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));

		BoneLocation = GetBoneCoords('lft_muzzle_flash');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(MissileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
		if(Proj != None)
		{
			PlaySound(Sound'WeaponSounds.RocketLauncher.RocketLauncherFire',SLOT_Interact);
		}
	}
}

simulated function BurnAway()
{
	if(bUseBurnAwayEffect && BurnFX != None)
	{
		Skins[0] = BurnFX;
		bBurning = true;
	}

	Super.BurnAway();
}

defaultproperties
{
     ProjectileDamage=50
     MissileDamage=200
     bMissileCanLock=True
     MissileClass=Class'tk_Quake4Monstersv1.Q4Harvester_Missile'
     MeleeAnims(0)="Attack_LLeg_Stab"
     MeleeAnims(1)="Attack_RLeg_Stab"
     MeleeAnims(2)="Attack_RLeg_F"
     MeleeAnims(3)="Attack_LLeg_F"
     HitAnims(0)="PainLight01"
     HitAnims(1)="PainLight02"
     HitAnims(2)="PainLight01"
     HitAnims(3)="PainLight02"
     DeathAnims(0)="Death01"
     DeathAnims(1)="Death02"
     DeathAnims(2)="Death01"
     DeathAnims(3)="Death02"
     RangedAttackAnims(0)="FireForward"
     RangedAttackAnims(1)="FireLong"
     RangedAttackAnims(2)="FireLong"
     RangedAttackAnims(3)="MissileFire"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Harvester.blade_impact_flesh1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Harvester.blade_impact_flesh2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Harvester.blade_impact_flesh3'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Harvester.blade_impact_flesh4'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.Harvester.step1'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.Harvester.step2'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.Harvester.step3'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.Harvester.step4'
     RangedAttackInterval=3.000000
     bCanBeTeleFrag=False
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=500
     NewHealth=3000
     bHasDeathAnim=True
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Harvester_Proj'
     bCanDodge=False
     HitSound(0)=Sound'tk_Quake4Monstersv1.Harvester.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Harvester.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Harvester.pain3'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Harvester.pain1'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Harvester.Death'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Harvester.Death'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Harvester.Death'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Harvester.Death'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Harvester.alert1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Harvester.alert2'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Harvester.alert3'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Harvester.alert4'
     FireSound=Sound'ONSVehicleSounds-S.LaserSounds.Laser17'
     ScoringValue=40
     WallDodgeAnims(0)="Walk01"
     WallDodgeAnims(1)="Walk01"
     WallDodgeAnims(2)="Walk01"
     WallDodgeAnims(3)="Walk01"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk01"
     FireHeavyBurstAnim="Walk01"
     FireRifleRapidAnim="Walk01"
     FireRifleBurstAnim="Walk01"
     bCanJump=False
     MeleeRange=220.000000
     GroundSpeed=240.000000
     Health=3000
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
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Harvester_mesh'
     DrawScale=0.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Harvester_skin01'
     CollisionRadius=150.000000
     CollisionHeight=120.000000
}

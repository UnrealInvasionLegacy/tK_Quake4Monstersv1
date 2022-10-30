class Q4Dropper extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;
var() config bool bCanSummon;
var() config int SummonLimit;
var() config float SpawnIntervalTime;
var() float LastSpawnTime;
var() name SphereLocNames[4];
var() name originSphereLocNames[4];
var() config string MonsterToSummon[3];

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
	else if(bCanSummon && NumSpawn < SummonLimit && Level.TimeSeconds - LastSpawnTime > SpawnIntervalTime)
	{
		SpawnSphere();
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastSpawnTime = Level.TimeSeconds;
	}
}

function SpawnSphere()
{
	local Q4Voss_SpawnSphere SS;
	local int i, j;
	local vector SphereLoc;
	local name SphereBone;

	j = Rand(4);
	SphereBone = SphereLocNames[j];
	SphereLoc = GetBoneCoords(SphereBone).Origin;
	SS = Spawn(class'Q4Voss_SpawnSphere',self,,SphereLoc,GetBoneRotation(originSphereLocNames[j]));

	if(SS != None)
	{
		SS.MonsterOwner = Self;
		for(i=0;i<3;i++)
		{
			SS.MonsterToSpawn[i] = MonsterToSummon[i];
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
		BoneLocation = GetBoneCoords('muzzle_flash');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,10));
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
		Skins[1] = InvisMat;
		bBurning = true;
	}

	Super.BurnAway();
}

defaultproperties
{
     ProjectileDamage=15
     bCanSummon=True
     SummonLimit=3
     SpawnIntervalTime=7.000000
     SphereLocNames(0)="'"
     SphereLocNames(1)="'"
     SphereLocNames(2)="'"
     SphereLocNames(3)="'"
     originSphereLocNames(0)="LF_canon"
     originSphereLocNames(1)="RF_canon"
     originSphereLocNames(2)="LR_canon"
     originSphereLocNames(3)="RR_canon"
     MonsterToSummon(0)="tk_Quake4Monstersv1.Q4Grunt"
     MonsterToSummon(1)="tk_Quake4Monstersv1.Q4Marine"
     MonsterToSummon(2)="tk_Quake4Monstersv1.Q4Marine"
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee01"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee01"
     HitAnims(0)="Pain02"
     HitAnims(1)="Pain03"
     HitAnims(2)="Pain02"
     HitAnims(3)="Pain03"
     DeathAnims(0)="Pain01"
     DeathAnims(1)="Pain01"
     DeathAnims(2)="Pain01"
     DeathAnims(3)="Pain01"
     RangedAttackAnims(0)="RangedAttack"
     RangedAttackAnims(1)="RangedAttack"
     RangedAttackAnims(2)="RangedAttack"
     RangedAttackAnims(3)="RangedAttack"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Dropper.bite1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Dropper.bite2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Dropper.bite1'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Dropper.bite2'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.Berserker.run01'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.Berserker.run02'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.Berserker.run03'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.Berserker.run04'
     RangedAttackInterval=8.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=20
     NewHealth=500
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Dropper_Proj'
     HitSound(0)=Sound'tk_Quake4Monstersv1.Dropper.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Dropper.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Dropper.pain3'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Dropper.pain1'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Dropper.death1'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Dropper.Death2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Dropper.death1'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Dropper.Death2'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Dropper.growl1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Dropper.growl2'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Dropper.alert2'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Dropper.alert1'
     FireSound=Sound'AssaultSounds.HumanShip.HnShipFire01'
     ScoringValue=12
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeL"
     WallDodgeAnims(2)="DodgeR"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle01"
     IdleRifleAnim="Idle02"
     FireHeavyRapidAnim="Run"
     FireHeavyBurstAnim="Run"
     FireRifleRapidAnim="Run"
     FireRifleBurstAnim="Run"
     MeleeRange=65.000000
     GroundSpeed=400.000000
     Health=500
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
     IdleCrouchAnim="Idle01"
     IdleSwimAnim="Idle02"
     IdleWeaponAnim="Idle02"
     IdleRestAnim="Idle01"
     IdleChatAnim="Idle02"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Dropper_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Dropper_skin01'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.Dropper_skin02'
     CollisionRadius=40.000000
     CollisionHeight=38.000000
}

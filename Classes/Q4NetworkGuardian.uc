class Q4NetworkGuardian extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;
var() config int MissileDamage;
var() config bool bMissileCanLock;
var() name FlyingAttacks[3];
var() Emitter ExhaustFX[2];
var() Emitter WingFX[2];

simulated function SpawnFlightFX()
{
	if(ExhaustFX[0] == None)
	{
		ExhaustFX[0] = Spawn(class'Q4NetworkGuardian_ExhaustFX',self,);
		if(ExhaustFX[0] != None)
		{
			AttachToBone(ExhaustFX[0],'l_jet');
		}
	}

	if(ExhaustFX[1] == None)
	{
		ExhaustFX[1] = Spawn(class'Q4NetworkGuardian_ExhaustFX',self,);
		if(ExhaustFX[1] != None)
		{
			AttachToBone(ExhaustFX[1],'r_jet');
		}
	}

	if(WingFX[0] == None)
	{
		WingFX[0] = Spawn(class'Q4NetworkGuardian_WingFX',self,);
		if(WingFX[0] != None)
		{
			AttachToBone(WingFX[0],'Lwing_fx');
		}
	}

	if(WingFX[1] == None)
	{
		WingFX[1] = Spawn(class'Q4NetworkGuardian_WingFX',self,);
		if(WingFX[1] != None)
		{
			AttachToBone(WingFX[1],'Rwing_fx');
		}
	}
}

simulated function DestroyFlightFX()
{
	local int i;

	for(i=0;i<2;i++)
	{
		if(ExhaustFX[i] != None)
		{
			ExhaustFX[i].Kill();
		}

		if(WingFX[i] != None)
		{
			WingFX[i].Kill();
		}
	}
}

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
		if(Q4NetworkGuardian_Proj(Other) != None)
		{
			Q4NetworkGuardian_Proj(Other).Damage = MissileDamage;
			Q4NetworkGuardian_Proj(Other).bMissileCanLock = bMissileCanLock;
		    if(Target != None)
			{
				Q4NetworkGuardian_Proj(Other).Seeking = Target;
			}
		}
		else if(Q4NetworkGuardian_Blaster(Other) != None)
		{
			Q4NetworkGuardian_Blaster(Other).Damage = ProjectileDamage;
		}
    }

    Super(Monster).GainedChild(Other);
}

function bool ShouldFly(Actor Enemy)
{
	if(Enemy != None)
	{
		if(Enemy.Location.Z - Location.Z > 300)
		{
			return true;
		}
	}

	return false;
}

simulated function RemoveEffects()
{
	DestroyFlightFX();
	Super.RemoveEffects();
}

function RangedAttack(Actor A)
{
    local vector X,Y,Z;

	if ( bShotAnim || A == None)
	{
		return;
	}

	Target = A;

	if(Physics == PHYS_Walking && ShouldFly(A))
	{
		GetAxes(Rotation,X,Y,Z);
		SetPhysics(PHYS_Flying);
		Controller.Destination = Location + 300 * Z;
		Velocity = AirSpeed * Z;
		Controller.GotoState('TacticalMove', 'DoMove');
	}

    if ( Physics == PHYS_Flying && Level.TimeSeconds - LastRangedAttack > RangedAttackInterval)
    {
        SetAnimAction(FlyingAttacks[Rand(3)]);
       	LastRangedAttack = Level.TimeSeconds;
		bShotAnim = true;
	}
	else if(VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		SetAnimAction(MeleeAnims[Rand(4)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		bShotAnim = true;
	}
	else if(Level.TimeSeconds - LastRangedAttack > RangedAttackInterval)
	{
	   	if (fRand() > 0.8 &&  !Controller.bPreparingMove && Controller.InLatentExecution(Controller.LATENT_MOVETOWARD) )
    	{
        	SetPhysics(PHYS_Flying);
       	 	SetAnimAction(FlyingAttacks[Rand(3)]);
       	 	bShotAnim = true;
       	 	return;
    	}
    	else
    	{
			SetAnimAction(RangedAttackAnims[Rand(4)]);
			Controller.bPreparingMove = true;
			Acceleration = vect(0,0,0);
			LastRangedAttack = Level.TimeSeconds;
			bShotAnim = true;
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
		BoneLocation = GetBoneCoords('fbone01');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4NetworkGuardian_Blaster',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,300));
		BoneLocation = GetBoneCoords('fbone02');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4NetworkGuardian_Blaster',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,300));
		BoneLocation = GetBoneCoords('fbone03');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4NetworkGuardian_Blaster',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,300));

		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	RemoveEffects();

	if(PHYSICS == PHYS_Walking)
	{
		bHasDeathAnim = true;
	}
	else
	{
		bHasDeathAnim = false;
	}

	if(bUseBurnAwayEffect)
	{
		BurnFX = QuakeBurnTex(Level.ObjectPool.AllocateObject(BurnClass));
		HandleDeath();

		if(BurnFX == None)
		{
			FallbackDeath();
			return;
		}

		PlayAnim(DeathAnims[Rand(4)],DeathSpeed, 0.1);
	}
	else if(bHasDeathAnim && !bUseBurnAwayEffect)
	{
		PlayAnim(DeathAnims[Rand(4)],, 0.1);
	}
	else
	{
		HandleDeath();
		FallbackDeath();
	}
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	if(Physics == PHYS_Flying)
	{
		PlayAnim('Fly_Pain01',, 0.1);
	}
	else
	{
 		PlayAnim(HitAnims[Rand(4)],, 0.1);
	}
}

function FireMissile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('l_muzzle_flash');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,300));

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
		bBurning = true;
	}

	Super.BurnAway();
}

function SetMovementPhysics()
{
    SetPhysics(PHYS_Flying);
}

event Landed(vector HitNormal)
{
    SetPhysics(PHYS_Walking);
    Super.Landed(HitNormal);
}

event HitWall( vector HitNormal, actor HitWall )
{
    if ( HitNormal.Z > MINFLOORZ )
        SetPhysics(PHYS_Walking);
    Super.HitWall(HitNormal,HitWall);
}

singular function Falling()
{
    SetPhysics(PHYS_Flying);
}

function PlayVictory()
{
    SetPhysics(PHYS_Falling);
    PlaySound(ChallengeSound[Rand(4)],SLOT_Interact);
}

defaultproperties
{
     ProjectileDamage=15
     MissileDamage=30
     bMissileCanLock=True
     FlyingAttacks(0)="Fly_Ranged01"
     FlyingAttacks(1)="Fly_Ranged01"
     FlyingAttacks(2)="Fly_Ranged01"
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee03"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee03"
     HitAnims(0)="Pain02"
     HitAnims(1)="Pain02"
     HitAnims(2)="Pain02"
     HitAnims(3)="Pain02"
     DeathAnims(0)="Pain01"
     DeathAnims(1)="Pain01"
     DeathAnims(2)="Pain01"
     DeathAnims(3)="Pain01"
     RangedAttackAnims(0)="Ranged01"
     RangedAttackAnims(1)="Ranged02"
     RangedAttackAnims(2)="Ranged04"
     RangedAttackAnims(3)="Ranged04"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.NetworkGuardian.growl1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.NetworkGuardian.growl2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.NetworkGuardian.growl1'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.NetworkGuardian.growl2'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.NetworkGuardian.step1'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.NetworkGuardian.step2'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.NetworkGuardian.step1'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.NetworkGuardian.step2'
     RangedAttackInterval=4.000000
     bCanBeTeleFrag=False
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=50
     NewHealth=4000
     bHasDeathAnim=True
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4NetworkGuardian_Proj'
     bCanDodge=False
     bTryToWalk=True
     HitSound(0)=Sound'tk_Quake4Monstersv1.NetworkGuardian.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.NetworkGuardian.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.NetworkGuardian.pain1'
     HitSound(3)=Sound'tk_Quake4Monstersv1.NetworkGuardian.pain2'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.NetworkGuardian.Death'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.NetworkGuardian.Death'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.NetworkGuardian.Death'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.NetworkGuardian.Death'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.NetworkGuardian.alert'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.NetworkGuardian.alert'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.NetworkGuardian.alert'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.NetworkGuardian.alert'
     FireSound=Sound'tk_Quake4Monstersv1.NetworkGuardian.rocket_fire'
     ScoringValue=35
     WallDodgeAnims(0)="Fly_DodgeL"
     WallDodgeAnims(1)="Fly_DodgeR"
     WallDodgeAnims(2)="Fly_DodgeL"
     WallDodgeAnims(3)="Fly_DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     bCanJump=False
     bCanFly=True
     bCanWalkOffLedges=True
     MeleeRange=200.000000
     GroundSpeed=240.000000
     Health=4000
     MovementAnims(0)="Walk"
     MovementAnims(1)="Walk"
     MovementAnims(2)="Walk"
     MovementAnims(3)="Walk"
     TurnLeftAnim="Walk"
     TurnRightAnim="Walk"
     SwimAnims(0)="Walk"
     SwimAnims(1)="Walk"
     SwimAnims(2)="Walk"
     SwimAnims(3)="Walk"
     CrouchAnims(0)="Walk"
     CrouchAnims(1)="Walk"
     CrouchAnims(2)="Walk"
     CrouchAnims(3)="Walk"
     WalkAnims(0)="Walk"
     WalkAnims(1)="Walk"
     WalkAnims(2)="Walk"
     WalkAnims(3)="Walk"
     AirAnims(0)="Fly_Idle"
     AirAnims(1)="Fly_Idle"
     AirAnims(2)="Fly_Idle"
     AirAnims(3)="Fly_Idle"
     TakeoffAnims(0)="Fly_Idle"
     TakeoffAnims(1)="Fly_Idle"
     TakeoffAnims(2)="Fly_Idle"
     TakeoffAnims(3)="Fly_Idle"
     LandAnims(0)="Walk"
     LandAnims(1)="Walk"
     LandAnims(2)="Walk"
     LandAnims(3)="Walk"
     DoubleJumpAnims(0)="Walk"
     DoubleJumpAnims(1)="Walk"
     DoubleJumpAnims(2)="Walk"
     DoubleJumpAnims(3)="Walk"
     DodgeAnims(0)="Walk"
     DodgeAnims(1)="Walk"
     DodgeAnims(2)="Walk"
     DodgeAnims(3)="Walk"
     AirStillAnim="Fly_Idle"
     TakeoffStillAnim="Fly_Idle"
     CrouchTurnRightAnim="Walk"
     CrouchTurnLeftAnim="Walk"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.NetworkGuardian_mesh'
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.NetworkGuardian_skin01'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.NetworkGuardian_skin02'
     CollisionRadius=150.000000
     CollisionHeight=155.000000
}

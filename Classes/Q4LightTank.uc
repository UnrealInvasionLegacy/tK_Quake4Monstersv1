class Q4LightTank extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;
var() float LastFlameTime;
var() config float FlameAttackInterval;
var() config int FlameDamagePerSecond;
var() bool bFlamePower;
var() float FlameRange;
var() Emitter FlameFX;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Q4LightTank_Proj(Other) != None)
        {
            Q4LightTank_Proj(Other).Damage = ProjectileDamage;
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
	else if(Dist < (FlameRange + CollisionRadius + A.CollisionRadius) && (Level.TimeSeconds - LastFlameTime > FlameAttackInterval))
	{
		SetAnimAction('FlameThrower');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastFlameTime = Level.TimeSeconds;
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
		BoneLocation = GetBoneCoords('gun_effect');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

simulated function RemoveEffects()
{
	if(FlameFX != None)
	{
		FlameFX.Kill();
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

simulated function FlameOn()
{
	local Coords BoneLocation;
	local Rotator BoneRotation;

	bFlamePower = true;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		BoneLocation = GetBoneCoords('gun_effect');
		BoneRotation = GetBoneRotation('gun_effect',);
		FlameFX = Spawn(class'Q4LightTank_FlameFX', Self,,BoneLocation.Origin,BoneRotation);
		AttachToBone(FlameFX,'gun_effect');
	}

	if(Role == Role_Authority)
	{
		PlaySound(Sound'tk_Quake4Monstersv1.LightTank.flame_start',SLOT_Interact);
		AmbientSound = Sound'tk_Quake4Monstersv1.LightTank.flame_loop';
	}
}

simulated function AnimEnd(int Channel)
{
	AmbientSound = None;
	bFlamePower = false;
	RemoveEffects();
	Super.AnimEnd(Channel);
}

simulated function FlameOff()
{
	bFlamePower = false;
	AmbientSound = None;
	RemoveEffects();
}

simulated State Flaming
{
	simulated function BeginState()
	{
		SetTimer(0.25,true);
	}

	simulated function EndState()
	{
		RemoveEffects();
	}

	function Timer()
	{
		local Pawn P;
		local float FlameDamage;
		local vector HitLoc, HitNorm, End, Start, X;

		if(bFlamePower)
		{
			FlameDamage = FlameDamagePerSecond/4;
			Start = GetBoneCoords('gun_effect').Origin;
	        X = Vector(GetBoneRotation('gun_effect'));
       		End = Start + FlameRange * X;

			foreach TraceActors(class'Pawn',P, HitLoc, HitNorm, End, Start, vect(50,50,50))
			{
				if(P != None && P != Self)
				{
					P.TakeDamage(int(FlameDamage), Self, P.Location, vect(1000,0,0), class'DamType_Q4LightTank');
				}
			}
		}
	}
}

defaultproperties
{
     ProjectileDamage=50
     FlameAttackInterval=7.000000
     FlameDamagePerSecond=10
     FlameRange=300.000000
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee02"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee02"
     HitAnims(0)="Pain02"
     HitAnims(1)="Pain03"
     HitAnims(2)="Pain04"
     HitAnims(3)="Pain02"
     DeathAnims(0)="Pain01"
     DeathAnims(1)="Pain01"
     DeathAnims(2)="Pain01"
     DeathAnims(3)="Pain01"
     RangedAttackAnims(0)="KneelAttack"
     RangedAttackAnims(1)="KneelAttack"
     RangedAttackAnims(2)="KneelAttack"
     RangedAttackAnims(3)="KneelAttack"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.LightTank.mace_swing1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.LightTank.mace_swing2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.LightTank.growl1'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.LightTank.growl2'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.LightTank.run1'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.LightTank.run2'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.LightTank.run3'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.LightTank.run4'
     RangedAttackInterval=3.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=50
     NewHealth=750
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4LightTank_Proj'
     HitSound(0)=Sound'tk_Quake4Monstersv1.LightTank.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.LightTank.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.LightTank.pain1'
     HitSound(3)=Sound'tk_Quake4Monstersv1.LightTank.pain2'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.LightTank.die1'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.LightTank.die2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.LightTank.die1'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.LightTank.die2'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.LightTank.sight1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.LightTank.sight2'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.LightTank.Breath2'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.LightTank.victory1'
     FireSound=Sound'tk_Quake4Monstersv1.LightTank.powerup_start'
     ScoringValue=8
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeR"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle01"
     IdleRifleAnim="Idle01"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     bCanJump=False
     MeleeRange=70.000000
     GroundSpeed=400.000000
     Health=750
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
     AirAnims(0)="Walk"
     AirAnims(1)="Walk"
     AirAnims(2)="Walk"
     AirAnims(3)="Walk"
     TakeoffAnims(0)="Walk"
     TakeoffAnims(1)="Walk"
     TakeoffAnims(2)="Walk"
     TakeoffAnims(3)="Walk"
     LandAnims(0)="Walk"
     LandAnims(1)="Walk"
     LandAnims(2)="Walk"
     LandAnims(3)="Walk"
     DoubleJumpAnims(0)="Walk"
     DoubleJumpAnims(1)="Walk"
     DoubleJumpAnims(2)="Walk"
     DoubleJumpAnims(3)="Walk"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Walk"
     TakeoffStillAnim="Walk"
     CrouchTurnRightAnim="Walk"
     CrouchTurnLeftAnim="Walk"
     IdleCrouchAnim="Idle01"
     IdleSwimAnim="Idle01"
     IdleWeaponAnim="Idle01"
     IdleRestAnim="Idle01"
     IdleChatAnim="Idle01"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.LightTank_mesh'
     InitialState="Flaming"
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.LightTank_skin01'
     CollisionRadius=30.000000
     CollisionHeight=70.000000
}

class Q4Makron extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage; //blasters 10
var() config int GrenadeDamage; //grenades 30
var() config int DarkProjectileDamage; //darkmatter proj 20
var() config int DarkGrenadeDamage; //darkmatter grenades 60
var() config bool bCanSummon;
var() config int SummonLimit;
var() config int ShockWaveDamage;
var() config float ShockWaveRadius;
var() config float SpawnIntervalTime;
var() float LastSpawnTime;
var() config int DarkMatterBeamDamagePerSec; //20
var() float DarkMatterBeamRange;
var() config string MonsterToSummon[3];
var() bool bLikeGrenades; //spawn grenades or blasters
var() bool bFlamePower;
var() Emitter FlameFX;
var() Rotator BeamRotation;
var() Vector BeamEnd, BeamLocation;
var() Sound MakronWin[6];
var() config bool bPlayEnglishSounds;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
		if(Q4Makron_Proj(Other) != None)
		{
			Q4Makron_Proj(Other).Damage = ProjectileDamage;
		}
		else if(Q4Makron_Grenade(Other) != None)
		{
			Q4Makron_Grenade(Other).Damage = GrenadeDamage;
		}
		else if(Q4Makron_DarkGrenade(Other) != None)
		{
			Q4Makron_DarkGrenade(Other).Damage = DarkGrenadeDamage;
		}
		else if(Q4Makron_DarkProj(Other) != None)
		{
			Q4Makron_DarkProj(Other).Damage = DarkProjectileDamage;
		}
    }

    Super(Monster).GainedChild(Other);
}

function SpawnSphere()
{
	local Q4Voss_SpawnSphere SS;
	local int i;

	SS = Spawn(class'Q4Voss_SpawnSphere',self,,GetBoneCoords('spheres').Origin,GetBoneRotation('spheres'));

	if(SS != None)
	{
		SS.MonsterOwner = Self;
		for(i=0;i<3;i++)
		{
			SS.MonsterToSpawn[i] = MonsterToSummon[i];
		}
	}
}

function RangedAttack(Actor A)
{
	local float Dist;

	if ( bShotAnim || A == None)
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
		if(fRand() < 0.1)
		{
			PlayLaugh();
		}

		if(Dist < ShockWaveRadius  + CollisionRadius + A.CollisionRadius )
		{
			if(fRand() > 0.5)
			{
				SetAnimAction('RangedArc');
			}
			else
			{
				SetAnimAction('Shockwave');
			}
		}
		else if(Dist < DarkMatterBeamRange + CollisionRadius + A.CollisionRadius )
		{
			if(fRand() > 0.75)
			{
				SetAnimAction('RangedArc');
			}
			else
			{
				SetAnimAction('RangedAttack02');
			}
		}
		else
		{
			bLikeGrenades = false;
			if(fRand() > 0.5)
			{
				bLikeGrenades = true;
			}
			//blasters or grenades or dark proj
			SetAnimAction(RangedAttackAnims[Rand(4)]);
		}

		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastRangedAttack = Level.TimeSeconds;
		bShotAnim = true;
	}
	else if(bCanSummon && NumSpawn < SummonLimit && Level.TimeSeconds - LastSpawnTime > SpawnIntervalTime)
	{
		if(fRand() < 0.25)
		{
			PlayLaugh();
		}

		SpawnSphere();
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastSpawnTime = Level.TimeSeconds;
	}
}

function PlayLaugh()
{
	PlaySound(MakronWin[0],SLOT_Interact);
}

simulated function DarkBeam()
{
	local Vector X,Y,Z;

	if(Target == None)
	{
		return;
	}

	bFlamePower = true;
	BeamLocation = GetBoneCoords('darkbone').Origin;
    BeamRotation = Rotator(Target.Location-BeamLocation);
    GetAxes(BeamRotation,X,Y,Z);
    BeamEnd = BeamLocation + DarkMatterBeamRange * X;
	if ( Level.NetMode != NM_DedicatedServer )
	{
		FlameFX = Spawn(class'Q4Makron_DarkMatterBeam', Self,, BeamLocation,BeamRotation);
	}

	if(Role == Role_Authority)
	{
		AmbientSound = Sound'tk_Quake4Monstersv1.Makron.lightning1';
	}
}

simulated function DarkBeamEnd()
{
	bFlamePower = false;
	AmbientSound = None;
	RemoveEffects();
}

simulated function AnimEnd(int Channel)
{
	AmbientSound = None;
	bFlamePower = false;
	RemoveEffects();
	Super.AnimEnd(Channel);
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
		local vector HitLoc, HitNorm;

		if(bFlamePower && Target !=None)
		{
			FlameDamage = DarkMatterBeamDamagePerSec/4;
			foreach TraceActors(class'Pawn',P, HitLoc, HitNorm, BeamEnd, BeamLocation, vect(50,50,50))
			{
				if(P != None && P != Self && !SameSpeciesAs(P))
				{
					P.TakeDamage(int(FlameDamage), Self, P.Location, vect(1000,0,0), class'DamType_Q4Makron');
				}
			}
		}
	}
}

function PlayVictory()
{
	if(!bPlayEnglishSounds)
	{
    	PlayLaugh();
	}
	else
	{
		PlaySound(MakronWin[Rand(6)],SLOT_Interact);
	}
}

function DarkMatter()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('cannon_muzzle');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4Makron_DarkProj',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,50));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Makron.bfg_fire',SLOT_Interact);
		}
	}
}

function PlayRearUp()
{
	PlaySound(Sound'tk_Quake4Monstersv1.Makron.rear_up',SLOT_Interact);
}

simulated function ShockWave()
{
	local Coords BoneLocation;

	BoneLocation = GetBoneCoords('shockbone');
	Spawn(class'Q4Makron_ShockFX',self,,BoneLocation.Origin + vect(0,0,25),);
	GroundShock(Mass/4);
}

function GroundShock(int Power)
{
	local float DamageScale, Dist, Shake;
    local vector Momentum, Dir;
    local Coords BoneLocation;
    local xPawn P;

	BoneLocation = GetBoneCoords('shockbone');
	PlaySound(HitSound[Rand(4)],SLOT_Interact);

	foreach RadiusActors(class'xPawn', P, ShockWaveRadius + CollisionRadius, BoneLocation.Origin)
	{
		if(P != None && P.Health > 0 && P != Self && P.Physics != PHYS_Falling && !SameSpeciesAs(P))
		{
			Dist = VSize(Location - P.Location);
			Momentum = 175 * Vrand();
		    Momentum.Z = FClamp(0,Power,Power - ( 0.4 * Dist + Max(10,P.Mass)*10));
			Dir = P.Location - BoneLocation.origin;
			Dist = FMax(1,VSize(Dir));
			Dir = Dir/Dist;
    		P.AddVelocity(Momentum);
			Shake = 0.4*FMax(500, Mass - Dist);
       		Shake=FMin(2000,Shake);
			DamageScale = 1 - FMax(0,(Dist - P.CollisionRadius)/(ShockWaveRadius + CollisionRadius));
			P.TakeDamage(DamageScale * ShockWaveDamage,self,P.Location - 0.5 * (P.CollisionHeight + P.CollisionRadius) * Dir,(DamageScale * Momentum * dir), class'DamType_Q4Makron');
            P.Controller.ShakeView( vect(0.0,0.02,0.0)*Shake, vect(0,1000,0),0.003*Shake, vect(0.02,0.02,0.02)*Shake, vect(1000,1000,1000),0.003*Shake);
		}
	}
}

function FireDarkGrenades()
{
	local Vector FireStart;
	local Vector SpawnOffset;
	local Coords BoneLocation;
	local Projectile Proj;
	local int i;
	local Rotator Rot, YawOffset;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('cannon_muzzle');
		FireStart = BoneLocation.Origin;
		for(i=0;i<4;i++)
		{
			SpawnOffset.X = RandRange(50,-50);
			SpawnOffset.Y = RandRange(50,-50);
			YawOffset.Yaw = RandRange(2000,6000);
			Rot = GetBoneRotation('cannon_muzzle');
			Rot = Rot + YawOffset;
			Proj = Spawn(class'Q4Makron_DarkGrenade',self,,FireStart+SpawnOffset,Rot);
		}

		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Makron.bfg_hit',SLOT_Interact,200, ,200);
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
		BoneLocation = GetBoneCoords('cannon_muzzle');
		FireStart = BoneLocation.Origin;
		if(bLikeGrenades)
		{
			Proj = Spawn(class'Q4Makron_Grenade',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,1000));
			if(Proj != None)
			{
				PlaySound(Sound'tk_Quake4Monstersv1.Makron.bfg_hit',SLOT_Interact);
			}
		}
		else
		{
			Proj = Spawn(class'Q4Makron_Proj',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,300));
			if(Proj != None)
			{
				PlaySound(FireSound,SLOT_Interact);
			}
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

simulated function RemoveEffects()
{
	if(FlameFX != None)
	{
		FlameFX.Kill();
	}
}

defaultproperties
{
     ProjectileDamage=10
     GrenadeDamage=30
     DarkProjectileDamage=20
     DarkGrenadeDamage=60
     bCanSummon=True
     SummonLimit=3
     ShockWaveDamage=35
     ShockWaveRadius=400.000000
     SpawnIntervalTime=7.000000
     DarkMatterBeamDamagePerSec=20
     DarkMatterBeamRange=750.000000
     MonsterToSummon(0)="tk_Quake4Monstersv1.Q4Grunt"
     MonsterToSummon(1)="tk_Quake4Monstersv1.Q4Marine"
     MonsterToSummon(2)="tk_Quake4Monstersv1.Q4Marine"
     MakronWin(0)=Sound'tk_Quake4Monstersv1.Makron.makronlaugh'
     MakronWin(1)=Sound'tk_Quake4Monstersv1.Makron.notgoodenough'
     MakronWin(2)=Sound'tk_Quake4Monstersv1.Makron.diehuman'
     MakronWin(3)=Sound'tk_Quake4Monstersv1.Makron.youwillfail'
     MakronWin(4)=Sound'tk_Quake4Monstersv1.Makron.pitiful'
     MakronWin(5)=Sound'tk_Quake4Monstersv1.Makron.youcannotwin'
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee01"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee01"
     HitAnims(0)="Pain01"
     HitAnims(1)="Pain02"
     HitAnims(2)="Pain03"
     HitAnims(3)="Pain02"
     DeathAnims(0)="Death"
     DeathAnims(1)="Death"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death"
     RangedAttackAnims(0)="RangedAttack01"
     RangedAttackAnims(1)="RangedAttack03"
     RangedAttackAnims(2)="RangedAttack04"
     RangedAttackAnims(3)="RangedAttack04"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Makron.blade_swing1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Makron.blade_swing2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Makron.blade_swing3'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Makron.blade_swing1'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.Makron.step1'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.Makron.step2'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.Makron.step3'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.Makron.step4'
     RangedAttackInterval=4.000000
     bCanBeTeleFrag=False
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=40
     NewHealth=2000
     bHasDeathAnim=True
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Harvester_Proj'
     DeathSpeed=0.500000
     bCanDodge=False
     HitSound(0)=Sound'tk_Quake4Monstersv1.Makron.Pain01'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Makron.Pain02'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Makron.Pain03'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Makron.Pain01'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Makron.Death'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Makron.Death'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Makron.Death'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Makron.Death'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Makron.Scream'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Gladiator.alert'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Makron.Scream'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Gladiator.alert'
     FireSound=Sound'ONSVehicleSounds-S.LaserSounds.Laser17'
     ScoringValue=35
     WallDodgeAnims(0)="WalkF"
     WallDodgeAnims(1)="WalkF"
     WallDodgeAnims(2)="WalkF"
     WallDodgeAnims(3)="WalkF"
     IdleHeavyAnim="Idle01"
     IdleRifleAnim="Idle01"
     FireHeavyRapidAnim="WalkF"
     FireHeavyBurstAnim="WalkF"
     FireRifleRapidAnim="WalkF"
     FireRifleBurstAnim="WalkF"
     bCanJump=False
     MeleeRange=170.000000
     GroundSpeed=240.000000
     Health=2000
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkF"
     MovementAnims(2)="WalkF"
     MovementAnims(3)="WalkF"
     TurnLeftAnim="WalkF"
     TurnRightAnim="WalkF"
     SwimAnims(0)="WalkF"
     SwimAnims(1)="WalkF"
     SwimAnims(2)="WalkF"
     SwimAnims(3)="WalkF"
     CrouchAnims(0)="WalkF"
     CrouchAnims(1)="WalkF"
     CrouchAnims(2)="WalkF"
     CrouchAnims(3)="WalkF"
     WalkAnims(1)="WalkF"
     WalkAnims(2)="WalkF"
     WalkAnims(3)="WalkF"
     AirAnims(0)="WalkF"
     AirAnims(1)="WalkF"
     AirAnims(2)="WalkF"
     AirAnims(3)="WalkF"
     TakeoffAnims(0)="WalkF"
     TakeoffAnims(1)="WalkF"
     TakeoffAnims(2)="WalkF"
     TakeoffAnims(3)="WalkF"
     LandAnims(0)="WalkF"
     LandAnims(1)="WalkF"
     LandAnims(2)="WalkF"
     LandAnims(3)="WalkF"
     DoubleJumpAnims(0)="WalkF"
     DoubleJumpAnims(1)="WalkF"
     DoubleJumpAnims(2)="WalkF"
     DoubleJumpAnims(3)="WalkF"
     DodgeAnims(0)="WalkF"
     DodgeAnims(1)="WalkF"
     DodgeAnims(2)="WalkF"
     DodgeAnims(3)="WalkF"
     AirStillAnim="WalkF"
     TakeoffStillAnim="WalkF"
     CrouchTurnRightAnim="WalkF"
     CrouchTurnLeftAnim="WalkF"
     IdleCrouchAnim="Idle01"
     IdleSwimAnim="Idle01"
     IdleWeaponAnim="Idle01"
     IdleRestAnim="Idle01"
     IdleChatAnim="Idle01"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Makron_mesh'
     InitialState="Flaming"
     DrawScale=1.200000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Makron_skin01'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.Makron_skin01'
     CollisionRadius=100.000000
     CollisionHeight=120.000000
}

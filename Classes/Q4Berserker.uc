//=============================================================================
// Q4Berserker.
//=============================================================================
class Q4Berserker extends Quake4Monster config(Quake4Monsters);

var() config int ShockDamage;
var() config float ShockRadius;
var() config int ProjectileDamage;

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
	else if(Dist > MeleeRange + CollisionRadius + A.CollisionRadius && Dist < ShockRadius  && Level.TimeSeconds - LastRangedAttack > RangedAttackInterval)
	{
		SetAnimAction(RangedAttackAnims[3]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastRangedAttack = Level.TimeSeconds;
		bShotAnim = true;
	}
	else if(Level.TimeSeconds - LastRangedAttack > RangedAttackInterval)
	{
		SetAnimAction(RangedAttackAnims[Rand(3)]);
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
		BoneLocation = GetBoneCoords('end_spike');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,10));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

simulated function GroundSlam()
{
	local Coords BoneLocation;

	BoneLocation = GetBoneCoords('SpikeBone');
	Spawn(class'Q4Berserker_ShockFX',self,,BoneLocation.Origin + vect(0,0,25),);
	ShockWaveDamage(Mass/4);
}

function ShockWaveDamage(int Power)
{
	local float DamageScale, Dist, Shake;
    local vector Momentum, Dir;
    local Coords BoneLocation;
    local xPawn P;

	BoneLocation = GetBoneCoords('SpikeBone');
	PlaySound(Sound'tk_Quake4Monstersv1.Berserker.pike_stab1',SLOT_Interact);

	foreach RadiusActors(class'xPawn', P, ShockRadius, BoneLocation.Origin)
	{
		if(P != None && P.Health > 0 && P != Self && P.Physics != PHYS_Falling && P.Controller != None && !P.Controller.IsA('MonsterController'))
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
			DamageScale = 1 - FMax(0,(Dist - P.CollisionRadius)/ShockRadius);
			P.TakeDamage(DamageScale * ShockDamage,self,P.Location - 0.5 * (P.CollisionHeight + P.CollisionRadius) * Dir,(DamageScale * Momentum * dir), class'DamType_Q4Berserker');
            P.Controller.ShakeView( vect(0.0,0.02,0.0)*Shake, vect(0,1000,0),0.003*Shake, vect(0.02,0.02,0.02)*Shake, vect(1000,1000,1000),0.003*Shake);
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
     ShockDamage=50
     ShockRadius=400.000000
     ProjectileDamage=25
     MeleeAnims(0)="Attack08"
     MeleeAnims(1)="Attack07"
     MeleeAnims(2)="Attack03"
     MeleeAnims(3)="Attack02"
     HitAnims(0)="Pain01"
     HitAnims(1)="Pain02"
     HitAnims(2)="Pain05"
     HitAnims(3)="Pain06"
     DeathAnims(0)="PainBig"
     DeathAnims(1)="PainBig"
     DeathAnims(2)="PainBig"
     DeathAnims(3)="PainBig"
     RangedAttackAnims(0)="Fire"
     RangedAttackAnims(1)="Fire"
     RangedAttackAnims(2)="Fire"
     RangedAttackAnims(3)="Attack05"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Berserker.mace_swing_1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Berserker.mace_swing_2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Berserker.mace_swing_3'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Berserker.mace_swing_1'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.Berserker.run01'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.Berserker.run02'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.Berserker.run03'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.Berserker.run04'
     RangedAttackInterval=8.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=30
     NewHealth=300
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Berserker_Proj'
     HitSound(0)=Sound'tk_Quake4Monstersv1.Berserker.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Berserker.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Berserker.pain3'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Berserker.pain1'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Berserker.die1'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Berserker.die2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Berserker.die1'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Berserker.die2'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Berserker.growl1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Berserker.growl2'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Berserker.grunt'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Berserker.sight3'
     FireSound=Sound'tk_Quake4Monstersv1.Berserker.Fire'
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
     MeleeRange=70.000000
     GroundSpeed=460.000000
     Health=300
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
     AirAnims(0)="InAir"
     AirAnims(1)="InAir"
     AirAnims(2)="InAir"
     AirAnims(3)="InAir"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="InAir"
     CrouchTurnRightAnim="Run"
     CrouchTurnLeftAnim="Run"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Berserker_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Berserker_skin01'
     CollisionHeight=70.000000
}

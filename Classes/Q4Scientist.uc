class Q4Scientist extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;
var() config int PlasmaDamage;
var() config int GasDamagePerSecond;
var() Emitter BodyFX;
var() Sound SawSounds[2];

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Q4Scientist_Proj(Other) != None)
        {
			Q4Scientist_Proj(Other).Damage = ProjectileDamage;
			Q4Scientist_Proj(Other).GasDamagePerSecond = GasDamagePerSecond;
		}
		else if(Q4Scientist_Dart(Other) != None)
		{
			Q4Scientist_Dart(Other).Damage = PlasmaDamage;
		}
    }

    Super(Monster).GainedChild(Other);
}

simulated function RemoveEffects()
{
	if(BodyFX != None)
	{
		BodyFX.Kill();
		BodyFX.Destroy();
	}
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if(Level.NetMode != NM_DedicatedServer)
    {
		if(BodyFX == None)
		{
			BodyFX = Spawn(class'Q4Scientist_HoverFX',self);
			AttachToBone(BodyFX,'effects_bone');
		}
	}
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
		if(Dist > 1000)
		{
			SetAnimAction(RangedAttackAnims[Rand(2)]);
		}
		else
		{
			SetAnimAction(RangedAttackAnims[Rand(4)]);
		}
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
		BoneLocation = GetBoneCoords('lft_wrist');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,Self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,0));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

function FireDart()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('lft_wrist');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4Scientist_Dart',Self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,0));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Scientist.chemical_burst3',SLOT_Interact);
		}
	}
}

simulated function BurnAway()
{
	RemoveEffects();

	if(bUseBurnAwayEffect && BurnFX != None)
	{
		Skins[0] = BurnFX;
		Skins[1] = BurnFX;
		Skins[2] = BurnFX;
		Skins[3] = BurnFX;
		bBurning = true;
	}

	Super.BurnAway();
}

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
    local vector X,Y,Z,duckdir;

    GetAxes(Rotation,X,Y,Z);
    if (DoubleClickMove == DCLICK_Forward)
        duckdir = X;
    else if (DoubleClickMove == DCLICK_Back)
        duckdir = -1*X;
    else if (DoubleClickMove == DCLICK_Left)
        duckdir = Y;
    else if (DoubleClickMove == DCLICK_Right)
        duckdir = -1*Y;

    Controller.Destination = Location + 200 * duckDir;
    Velocity = AirSpeed * duckDir;
    Controller.GotoState('TacticalMove', 'DoMove');
    return true;
}

function SetMovementPhysics()
{
    SetPhysics(PHYS_Flying);
}

singular function Falling()
{
    SetPhysics(PHYS_Flying);
}

function PlaySaw()
{
	PlaySound(SawSounds[Rand(2)],SLOT_Misc);
}

defaultproperties
{
     ProjectileDamage=10
     PlasmaDamage=15
     GasDamagePerSecond=5
     SawSounds(0)=Sound'tk_Quake4Monstersv1.Scientist.saw1'
     SawSounds(1)=Sound'tk_Quake4Monstersv1.Scientist.saw2'
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee03"
     MeleeAnims(2)="Melee03"
     MeleeAnims(3)="Melee04"
     HitAnims(0)="Pain02"
     HitAnims(1)="Pain04"
     HitAnims(2)="Pain02"
     HitAnims(3)="Pain04"
     DeathAnims(0)="Pain01"
     DeathAnims(1)="Pain01"
     DeathAnims(2)="Pain01"
     DeathAnims(3)="Pain01"
     RangedAttackAnims(0)="Melee02"
     RangedAttackAnims(1)="Melee02"
     RangedAttackAnims(2)="Throw"
     RangedAttackAnims(3)="Throw"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Scientist.Attack'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Scientist.attack2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Scientist.Attack'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Scientist.attack2'
     RangedAttackInterval=3.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=20
     NewHealth=150
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Scientist_Proj'
     HitSound(0)=Sound'tk_Quake4Monstersv1.Scientist.Attack'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Scientist.Attack'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Scientist.Attack'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Scientist.Attack'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Scientist.attack2'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Scientist.attack2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Scientist.attack2'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Scientist.attack2'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Scientist.voice_1a'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Scientist.voice_2a'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Scientist.voice_3a'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Scientist.voice_4a'
     FireSound=Sound'tk_Quake4Monstersv1.Scientist.voice_9a'
     ScoringValue=10
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeL"
     WallDodgeAnims(2)="DodgeR"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="IdleTwitch"
     IdleRifleAnim="IdleTwitch"
     FireHeavyRapidAnim="Forward01"
     FireHeavyBurstAnim="Forward01"
     FireRifleRapidAnim="Forward01"
     FireRifleBurstAnim="Forward01"
     bCanFly=True
     MeleeRange=80.000000
     GroundSpeed=300.000000
     AirSpeed=300.000000
     Health=150
     MovementAnims(0)="Forward01"
     MovementAnims(1)="Forward01"
     MovementAnims(2)="Forward01"
     MovementAnims(3)="Forward01"
     TurnLeftAnim="Forward01"
     TurnRightAnim="Forward01"
     SwimAnims(0)="Forward01"
     SwimAnims(1)="Forward01"
     SwimAnims(2)="Forward01"
     SwimAnims(3)="Forward01"
     CrouchAnims(0)="Forward01"
     CrouchAnims(1)="Forward01"
     CrouchAnims(2)="Forward01"
     CrouchAnims(3)="Forward01"
     WalkAnims(0)="Forward01"
     WalkAnims(1)="Forward01"
     WalkAnims(2)="Forward01"
     WalkAnims(3)="Forward01"
     AirAnims(0)="Forward01"
     AirAnims(1)="Forward01"
     AirAnims(2)="Forward01"
     AirAnims(3)="Forward01"
     TakeoffAnims(0)="Forward01"
     TakeoffAnims(1)="Forward01"
     TakeoffAnims(2)="Forward01"
     TakeoffAnims(3)="Forward01"
     LandAnims(0)="Forward01"
     LandAnims(1)="Forward01"
     LandAnims(2)="Forward01"
     LandAnims(3)="Forward01"
     DoubleJumpAnims(0)="Forward01"
     DoubleJumpAnims(1)="Forward01"
     DoubleJumpAnims(2)="Forward01"
     DoubleJumpAnims(3)="Forward01"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Forward01"
     TakeoffStillAnim="Forward01"
     CrouchTurnRightAnim="Forward01"
     CrouchTurnLeftAnim="Forward01"
     IdleCrouchAnim="IdleTwitch"
     IdleSwimAnim="IdleTwitch"
     IdleWeaponAnim="IdleTwitch"
     IdleRestAnim="IdleTwitch"
     IdleChatAnim="IdleTwitch"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Scientist_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Scientist_skin02'
     Skins(1)=TexRotator'tk_Quake4Monstersv1.MonsterTextures.Scientist_skin04'
     Skins(2)=TexRotator'tk_Quake4Monstersv1.MonsterTextures.Scientist_skin04'
     Skins(3)=Texture'tk_Quake4Monstersv1.MonsterTextures.Scientist_skin01'
     CollisionRadius=30.000000
     CollisionHeight=70.000000
}

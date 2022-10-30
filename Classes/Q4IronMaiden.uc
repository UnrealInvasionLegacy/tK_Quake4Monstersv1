class Q4IronMaiden extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;
var() config bool bIronMaidenCanTeleport;
var() config float TeleportIntervalTime;
var() config int ScreamDamagePerSecond;
var() float LastTeleportTime;
var() Sound TeleportSounds[3];
var() NavigationPoint OldNode;
var() bool bFlamePower;
var() Emitter FlameFX;
var() Rotator BeamRotation;
var() Vector BeamEnd, BeamLocation;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Q4IronMaiden_Proj(Other) != None)
        {
			Q4IronMaiden_Proj(Other).Damage = ProjectileDamage;
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
		if(fRand() > 0.5)
		{
			SetAnimAction(MeleeAnims[Rand(4)]);
		}
		else
		{
			SetAnimAction('Banshee');
		}

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
	else if(bIronMaidenCanTeleport && Level.TimeSeconds - LastTeleportTime > TeleportIntervalTime)
	{
		SetAnimAction('Teleport');
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastTeleportTime = Level.TimeSeconds;
		bShotAnim = true;
	}
}

simulated function Scream()
{
	if(Target == None)
	{
		return;
	}

	bFlamePower = true;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		FlameFX = Spawn(class'Q4IronMaiden_ScreamFX', Self);
		if(FlameFX != None)
		{
			AttachToBone(FlameFX,'mouth_effect');
		}
	}
}

simulated function ScreamEnd()
{
	bFlamePower = false;
	RemoveEffects();
}

simulated function AnimEnd(int Channel)
{
	AmbientSound = None;
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
		local Vector X,Y,Z;

		if(bFlamePower && Target !=None)
		{
			FlameDamage = ScreamDamagePerSecond/4;
			BeamLocation = GetBoneCoords('mouth_effect').Origin;
			BeamRotation = Rotator(Target.Location-BeamLocation);
			GetAxes(BeamRotation,X,Y,Z);
			BeamEnd = BeamLocation + 200 * X;
			foreach TraceActors(class'Pawn',P, HitLoc, HitNorm, BeamEnd, BeamLocation, vect(50,50,50))
			{
				if(P != None && P != Self && !SameSpeciesAs(P))
				{
					P.TakeDamage(int(FlameDamage), Self, P.Location, vect(1000,0,0), class'DamType_Q4IronMaiden');
				}
			}
		}
	}
}

simulated function TeleportButton()
{
	if(Role == Role_Authority)
	{
		PlaySound(Sound'tk_Quake4Monstersv1.IronMaiden.Button',SLOT_Interact);
	}

   	if(Level.NetMode != NM_DedicatedServer)
    {
		Spawn(class'Q4IronMaiden_TeleportFX',self,,location);
	}
}

simulated function IronMaidenTeleport()
{
	local vector OldLocation, DesiredLocation;

	if(Role == Role_Authority && Target != None)
	{

 		OldLocation = Location;

        if(Health > (default.Health/10))
        {
            DesiredLocation = GetTeleLocation(OldLocation, Target.Location);
        }
        else
        {
            DesiredLocation = GetTeleLocation(OldLocation,Location);
        }

        if(DesiredLocation != vect(0,0,0))
        {
            if(SetLocation(DesiredLocation))
            {
				PlaySound(TeleportSounds[Rand(3)],SLOT_Interact);
                Controller.Destination = Target.Location;
                Controller.bPreparingMove = true;
                Acceleration = vect(0,0,0);
                bShotAnim = true;
            }
        }
    }

    if(Level.NetMode != NM_DedicatedServer)
    {
		Spawn(class'Q4IronMaiden_TeleportFX',self,,location);
	}
}

function vector GetTeleLocation(vector OldLoc, vector TargetLocPoint)
{
    local int NodeCounter;
    local NavigationPoint NodeList[50];
    local NavigationPoint Node;

    foreach RadiusActors(class'NavigationPoint', Node, 1000, TargetLocPoint)
    {
        if(Node != None && Node.Region.ZoneNumber == Region.ZoneNumber)
        {
            if(NodeCounter < 50)
            {
                NodeList[NodeCounter] = Node;
                NodeCounter++;
            }
        }
    }

    Node = NodeList[RandRange(0, NodeCounter)];
    if(Node != None && Node != OldNode)
    {
        OldNode = Node;
        return Node.Location;
    }
    else
    {
        return OldLoc;
    }
}
//missile
function FireProjectile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('muzzle_flash');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,0));
		if(Proj != None)
		{
			PlaySound(Sound'WeaponSounds.RocketLauncher.RocketLauncherFire',SLOT_Interact);
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

simulated function RemoveEffects()
{
	if(FlameFX != None)
	{
		FlameFX.Kill();
	}
}

defaultproperties
{
     ProjectileDamage=30
     bIronMaidenCanTeleport=True
     TeleportIntervalTime=7.000000
     ScreamDamagePerSecond=20
     TeleportSounds(0)=Sound'tk_Quake4Monstersv1.IronMaiden.breath1'
     TeleportSounds(1)=Sound'tk_Quake4Monstersv1.IronMaiden.Breath2'
     TeleportSounds(2)=Sound'tk_Quake4Monstersv1.IronMaiden.breath3'
     MeleeAnims(0)="Attack01"
     MeleeAnims(1)="Attack02"
     MeleeAnims(2)="Attack01"
     MeleeAnims(3)="Attack02"
     HitAnims(0)="Pain02"
     HitAnims(1)="Pain02"
     HitAnims(2)="Pain02"
     HitAnims(3)="Pain02"
     DeathAnims(0)="Pain01"
     DeathAnims(1)="Pain01"
     DeathAnims(2)="Pain01"
     DeathAnims(3)="Pain01"
     RangedAttackAnims(0)="RangedAttack01"
     RangedAttackAnims(1)="RangedAttack02"
     RangedAttackAnims(2)="RangedAttack01"
     RangedAttackAnims(3)="RangedAttack02"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.IronMaiden.attack1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.IronMaiden.attack2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.IronMaiden.attack1'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.IronMaiden.attack2'
     RangedAttackInterval=3.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=30
     NewHealth=300
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4IronMaiden_Proj'
     HitSound(0)=Sound'tk_Quake4Monstersv1.IronMaiden.attack1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.IronMaiden.attack2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.IronMaiden.attack1'
     HitSound(3)=Sound'tk_Quake4Monstersv1.IronMaiden.attack2'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.IronMaiden.die1'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.IronMaiden.die2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.IronMaiden.die1'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.IronMaiden.die2'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.IronMaiden.alert1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.IronMaiden.alert2'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.IronMaiden.alert1'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.IronMaiden.alert2'
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     ScoringValue=8
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeL"
     WallDodgeAnims(2)="DodgeR"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Forward"
     FireHeavyBurstAnim="Forward"
     FireRifleRapidAnim="Forward"
     FireRifleBurstAnim="Forward"
     bCanFly=True
     MeleeRange=85.000000
     GroundSpeed=500.000000
     AirSpeed=500.000000
     Health=300
     MovementAnims(0)="Forward"
     MovementAnims(1)="Forward"
     MovementAnims(2)="Forward"
     MovementAnims(3)="Forward"
     TurnLeftAnim="Forward"
     TurnRightAnim="Forward"
     SwimAnims(0)="Forward"
     SwimAnims(1)="Forward"
     SwimAnims(2)="Forward"
     SwimAnims(3)="Forward"
     CrouchAnims(0)="Forward"
     CrouchAnims(1)="Forward"
     CrouchAnims(2)="Forward"
     CrouchAnims(3)="Forward"
     WalkAnims(0)="Forward"
     WalkAnims(1)="Forward"
     WalkAnims(2)="Forward"
     WalkAnims(3)="Forward"
     AirAnims(0)="Forward"
     AirAnims(1)="Forward"
     AirAnims(2)="Forward"
     AirAnims(3)="Forward"
     TakeoffAnims(0)="Forward"
     TakeoffAnims(1)="Forward"
     TakeoffAnims(2)="Forward"
     TakeoffAnims(3)="Forward"
     LandAnims(0)="Forward"
     LandAnims(1)="Forward"
     LandAnims(2)="Forward"
     LandAnims(3)="Forward"
     DoubleJumpAnims(0)="Forward"
     DoubleJumpAnims(1)="Forward"
     DoubleJumpAnims(2)="Forward"
     DoubleJumpAnims(3)="Forward"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Forward"
     TakeoffStillAnim="Forward"
     CrouchTurnRightAnim="Forward"
     CrouchTurnLeftAnim="Forward"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.IronMaiden_mesh'
     InitialState="Flaming"
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.IronMaiden_skin01'
     Skins(1)=Shader'tk_Quake4Monstersv1.MonsterTextures.IronMaiden_shader'
     Skins(2)=Texture'tk_Quake4Monstersv1.MonsterTextures.IronMaiden_skin03'
     CollisionRadius=30.000000
     CollisionHeight=70.000000
}

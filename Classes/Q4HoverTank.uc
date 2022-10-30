class Q4HoverTank extends Quake4Monster config(Quake4Monsters);

var() config int MissileDamage;
var() config bool bMissileCanLock;
var() config int ProjectileDamage;
var() class<Projectile> BlasterClass;
var() Emitter BodyFX;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if(Level.NetMode != NM_DedicatedServer)
    {
		if(BodyFX == None)
		{
			BodyFX = Spawn(class'Q4HoverTank_HoverFX',self);
			AttachToBone(BodyFX,'fx');
		}
	}
}

simulated function RemoveEffects()
{
	if(BodyFX != None)
	{
		BodyFX.Kill();
		BodyFX.Destroy();
	}
}

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Q4HoverTank_Missile(Other) != None)
        {
            Q4HoverTank_Missile(Other).Damage = MissileDamage;
            Q4HoverTank_Missile(Other).bMissileCanLock = bMissileCanLock;
        	if(Target != None)
			{
				Q4HoverTank_Missile(Other).Seeking = Target;
			}
        }
        else if(Q4HoverTank_Proj(Other) != None)
        {
			Q4HoverTank_Proj(Other).Damage = ProjectileDamage;
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

function FireBlaster()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('machine_gun_barrel');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(BlasterClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
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
		Skins[2] = InvisMat;
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

defaultproperties
{
     MissileDamage=50
     bMissileCanLock=True
     ProjectileDamage=10
     BlasterClass=Class'tk_Quake4Monstersv1.Q4HoverTank_Proj'
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
     RangedAttackAnims(0)="BigGun01"
     RangedAttackAnims(1)="SmallBlast"
     RangedAttackAnims(2)="SmallBlast"
     RangedAttackAnims(3)="SmallBlast"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.HoverTank.pain1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.HoverTank.pain2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.HoverTank.pain1'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.HoverTank.pain2'
     RangedAttackInterval=2.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=35
     NewHealth=800
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4HoverTank_Missile'
     HitSound(0)=Sound'tk_Quake4Monstersv1.HoverTank.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.HoverTank.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.HoverTank.pain1'
     HitSound(3)=Sound'tk_Quake4Monstersv1.HoverTank.pain2'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.HoverTank.pain1'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.HoverTank.pain2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.HoverTank.pain1'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.HoverTank.pain2'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.HoverTank.alert'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.HoverTank.chatter_combat1'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.HoverTank.chatter_combat1'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.HoverTank.chatter1'
     FireSound=Sound'ONSVehicleSounds-S.LaserSounds.Laser04'
     ScoringValue=10
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeL"
     WallDodgeAnims(2)="DodgeR"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     bCanFly=True
     MeleeRange=75.000000
     GroundSpeed=600.000000
     AirSpeed=600.000000
     Health=800
     MovementAnims(0)="Idle"
     MovementAnims(1)="Idle"
     MovementAnims(2)="Idle"
     MovementAnims(3)="Idle"
     TurnLeftAnim="Idle"
     TurnRightAnim="Idle"
     SwimAnims(0)="Idle"
     SwimAnims(1)="Idle"
     SwimAnims(2)="Idle"
     SwimAnims(3)="Idle"
     CrouchAnims(0)="Idle"
     CrouchAnims(1)="Idle"
     CrouchAnims(2)="Idle"
     CrouchAnims(3)="Idle"
     WalkAnims(0)="Idle"
     WalkAnims(1)="Idle"
     WalkAnims(2)="Idle"
     WalkAnims(3)="Idle"
     AirAnims(0)="Idle"
     AirAnims(1)="Idle"
     AirAnims(2)="Idle"
     AirAnims(3)="Idle"
     TakeoffAnims(0)="Idle"
     TakeoffAnims(1)="Idle"
     TakeoffAnims(2)="Idle"
     TakeoffAnims(3)="Idle"
     LandAnims(0)="Idle"
     LandAnims(1)="Idle"
     LandAnims(2)="Idle"
     LandAnims(3)="Idle"
     DoubleJumpAnims(0)="Idle"
     DoubleJumpAnims(1)="Idle"
     DoubleJumpAnims(2)="Idle"
     DoubleJumpAnims(3)="Idle"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     DodgeAnims(2)="DodgeL"
     DodgeAnims(3)="DodgeR"
     AirStillAnim="Idle"
     TakeoffStillAnim="Idle"
     CrouchTurnRightAnim="Idle"
     CrouchTurnLeftAnim="Idle"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     AmbientSound=Sound'tk_Quake4Monstersv1.HoverTank.hover_loop'
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.HoverTank_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.HoverTank_skin01'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.HoverTank_skin02'
     Skins(2)=Texture'tk_Quake4Monstersv1.MonsterTextures.HoverTank_skin03'
     Skins(3)=Texture'tk_Quake4Monstersv1.MonsterTextures.FailedTransfer_skin01'
     CollisionRadius=40.000000
     CollisionHeight=55.000000
}

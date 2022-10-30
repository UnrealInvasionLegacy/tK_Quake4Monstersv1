class Q4RepairBot extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Q4RepairBot_Proj(Other) != None)
        {
			Q4RepairBot_Proj(Other).Damage = ProjectileDamage;
		}
    }

    Super(Monster).GainedChild(Other);
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
	{
		return;
	}

	Target = A;

	if(Level.TimeSeconds - LastRangedAttack > RangedAttackInterval)
	{
		SetAnimAction(RangedAttackAnims[Rand(4)]);
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
		BoneLocation = GetBoneCoords('l_fx');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,0));
		BoneLocation = GetBoneCoords('r_fx');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,0));

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
		Skins[1] = InvisMat;
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
     ProjectileDamage=30
     MeleeAnims(0)="Pain01"
     MeleeAnims(1)="Pain01"
     MeleeAnims(2)="Pain01"
     MeleeAnims(3)="Pain01"
     HitAnims(0)="Pain01"
     HitAnims(1)="Pain02"
     HitAnims(2)="Pain01"
     HitAnims(3)="Pain02"
     DeathAnims(0)="Death"
     DeathAnims(1)="Death"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death"
     RangedAttackAnims(0)="Attack01"
     RangedAttackAnims(1)="Attack01"
     RangedAttackAnims(2)="Attack01"
     RangedAttackAnims(3)="Attack01"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.RepairBot.servo1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.RepairBot.servo2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.RepairBot.servo3'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.RepairBot.servo4'
     RangedAttackInterval=1.500000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=30
     NewHealth=100
     bHasDeathAnim=True
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4RepairBot_Proj'
     bMeleeFighter=False
     HitSound(0)=Sound'tk_Quake4Monstersv1.RepairBot.servo1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.RepairBot.servo2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.RepairBot.servo3'
     HitSound(3)=Sound'tk_Quake4Monstersv1.RepairBot.servo4'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.RepairBot.Die'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.RepairBot.Die'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.RepairBot.Die'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.RepairBot.Die'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.RepairBot.chatter1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.RepairBot.chatter2'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.RepairBot.chatter3'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.RepairBot.chatter4'
     FireSound=Sound'tk_Quake4Monstersv1.grunt.blaster03'
     ScoringValue=8
     WallDodgeAnims(0)="Forward"
     WallDodgeAnims(1)="Forward"
     WallDodgeAnims(2)="Forward"
     WallDodgeAnims(3)="Forward"
     IdleHeavyAnim="Idle01"
     IdleRifleAnim="Idle01"
     FireHeavyRapidAnim="Forward"
     FireHeavyBurstAnim="Forward"
     FireRifleRapidAnim="Forward"
     FireRifleBurstAnim="Forward"
     bCanFly=True
     GroundSpeed=600.000000
     AirSpeed=600.000000
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
     DodgeAnims(0)="Forward"
     DodgeAnims(1)="Forward"
     DodgeAnims(2)="Forward"
     DodgeAnims(3)="Forward"
     AirStillAnim="Forward"
     TakeoffStillAnim="Forward"
     CrouchTurnRightAnim="Forward"
     CrouchTurnLeftAnim="Forward"
     IdleCrouchAnim="Idle01"
     IdleSwimAnim="Idle01"
     IdleWeaponAnim="Idle01"
     IdleRestAnim="Idle01"
     IdleChatAnim="Idle01"
     AmbientSound=Sound'tk_Quake4Monstersv1.RepairBot.hover_loop'
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.RepairBot_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.RepairBot_skin01'
     Skins(1)=Texture'UCGeneric.Glass.glass10'
     SoundRadius=100.000000
     CollisionRadius=20.000000
     CollisionHeight=20.000000
}

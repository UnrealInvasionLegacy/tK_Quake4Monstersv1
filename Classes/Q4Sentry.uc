class Q4Sentry extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Q4Sentry_Proj(Other) != None)
        {
			Q4Sentry_Proj(Other).Damage = ProjectileDamage;
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
		BoneLocation = GetBoneCoords('muzzleflash_l');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,Self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
		BoneLocation = GetBoneCoords('muzzleflash_r');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,Self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,100));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

simulated function HandleDeath()
{
	SetOverlayMaterial(None, 0.0f, true);
	SetCollision(false, false, false);
	Projectors.Remove(0, Projectors.Length);
	bAcceptsProjectors = false;
	if(PlayerShadow != None)
	{
		PlayerShadow.bShadowActive = false;
	}
	RemoveFlamingEffects();
	BurnAway();
}

simulated function PlayDirectionalHit(Vector HitLoc)
{}

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
     ProjectileDamage=8
     HitAnims(0)="Idle"
     HitAnims(1)="Idle"
     HitAnims(2)="Idle"
     HitAnims(3)="Idle"
     DeathAnims(0)="Idle"
     DeathAnims(1)="Idle"
     DeathAnims(2)="Idle"
     DeathAnims(3)="Idle"
     RangedAttackAnims(0)="RangedAttack"
     RangedAttackAnims(1)="RangedAttack"
     RangedAttackAnims(2)="RangedAttack"
     RangedAttackAnims(3)="RangedAttack"
     RangedAttackInterval=0.250000
     bUseDamageConfig=True
     bUseHealthConfig=True
     NewHealth=150
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Sentry_Proj'
     bMeleeFighter=False
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'tk_Quake4Monstersv1.Sentry.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Sentry.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Sentry.pain1'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Sentry.pain2'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Sentry.die1'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Sentry.die2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Sentry.die1'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Sentry.die2'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Sentry.voice_1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Sentry.voice_2'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Sentry.voice_3'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Sentry.voice_4'
     FireSound=Sound'tk_Quake4Monstersv1.Sentry.Fire1'
     ScoringValue=10
     WallDodgeAnims(0)="Idle"
     WallDodgeAnims(1)="Idle"
     WallDodgeAnims(2)="Idle"
     WallDodgeAnims(3)="Idle"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     bCanFly=True
     GroundSpeed=500.000000
     AirSpeed=500.000000
     Health=150
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
     DodgeAnims(0)="Idle"
     DodgeAnims(1)="Idle"
     DodgeAnims(2)="Idle"
     DodgeAnims(3)="Idle"
     AirStillAnim="Idle"
     TakeoffStillAnim="Idle"
     CrouchTurnRightAnim="Idle"
     CrouchTurnLeftAnim="Idle"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     AmbientSound=Sound'tk_Quake4Monstersv1.Sentry.sentry_hover'
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Sentry_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Sentry_skin01'
     Skins(1)=Shader'tk_Quake4Monstersv1.MonsterTextures.Sentry_shader'
     SoundVolume=100
     SoundRadius=300.000000
     CollisionRadius=30.000000
     CollisionHeight=60.000000
}

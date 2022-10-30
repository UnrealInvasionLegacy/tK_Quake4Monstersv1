class Q4FailedTransfer extends Quake4Monster config(Quake4Monsters);

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
	else if(Level.TimeSeconds - LastRangedAttack > RangedAttackInterval)
	{
		SetAnimAction(RangedAttackAnims[Rand(4)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastRangedAttack = Level.TimeSeconds;
		bShotAnim = true;
	}
}

simulated function FireProjectile()
{
	local Vector FireStart,X,Y,Z;
	local Coords BoneLocation;
	local Projectile Proj;
	local int i;

	BoneLocation = GetBoneCoords('MuzzleFlash');
	if ( Controller != None )
	{
		GetAxes(Rotation,X,Y,Z);

		for(i=0;i<6;i++)
		{
			FireStart = BoneLocation.Origin + RandRange(-5,5) * Y + RandRange(-5,5) * Z;
			Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,10));
		}

		PlaySound(FireSound,SLOT_Interact);
	}

	if(Level.NetMode != NM_DedicatedServer)
	{
		Spawn(class'Q4FailedTransfer_WeaponFlash',self,,BoneLocation.Origin);
	}
}

simulated function BurnAway()
{
	if(bUseBurnAwayEffect && BurnFX != None)
	{
		Skins[0] = BurnFX;
		Skins[1] = InvisMat;
		Skins[2] = InvisMat;
		bBurning = true;
	}

	Super.BurnAway();
}

defaultproperties
{
     ProjectileDamage=8
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee02"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee02"
     HitAnims(0)="Pain01"
     HitAnims(1)="Pain03"
     HitAnims(2)="Pain02"
     HitAnims(3)="Pain01"
     DeathAnims(0)="DeathNormal"
     DeathAnims(1)="DeathNormal"
     DeathAnims(2)="DeathNormal"
     DeathAnims(3)="DeathNormal"
     RangedAttackAnims(0)="Shotgun01"
     RangedAttackAnims(1)="Shotgun02"
     RangedAttackAnims(2)="Shotgun03"
     RangedAttackAnims(3)="Shotgun04"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.FailedTransfer.growl1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.FailedTransfer.growl2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.FailedTransfer.growl1'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.FailedTransfer.growl2'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.FailedTransfer.flesh1'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.FailedTransfer.flesh2'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.FailedTransfer.flesh3'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.FailedTransfer.flesh1'
     RangedAttackInterval=5.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=10
     NewHealth=70
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4FailedTransfer_Proj'
     bCanDodge=False
     HitSound(0)=Sound'tk_Quake4Monstersv1.FailedTransfer.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.FailedTransfer.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.FailedTransfer.pain3'
     HitSound(3)=Sound'tk_Quake4Monstersv1.FailedTransfer.pain1'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.FailedTransfer.die1'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.FailedTransfer.die2'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.FailedTransfer.die3'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.FailedTransfer.die2'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.FailedTransfer.chatter1'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.FailedTransfer.chatter2'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.FailedTransfer.chatter3'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.FailedTransfer.chatter4'
     FireSound=Sound'ONSBPSounds.Artillery.ShellBrakingExplode'
     ScoringValue=6
     WallDodgeAnims(0)="Walk01"
     WallDodgeAnims(1)="Walk01"
     WallDodgeAnims(2)="Walk01"
     WallDodgeAnims(3)="Walk01"
     IdleHeavyAnim="Idle_Alert"
     IdleRifleAnim="Idle_Alert"
     FireHeavyRapidAnim="Walk01"
     FireHeavyBurstAnim="Walk01"
     FireRifleRapidAnim="Walk01"
     FireRifleBurstAnim="Walk01"
     bCanJump=False
     MeleeRange=70.000000
     GroundSpeed=200.000000
     Health=70
     MovementAnims(0)="Walk01"
     MovementAnims(1)="Walk01"
     MovementAnims(2)="Walk01"
     MovementAnims(3)="Walk01"
     TurnLeftAnim="Walk01"
     TurnRightAnim="Walk01"
     SwimAnims(0)="Walk01"
     SwimAnims(1)="Walk01"
     SwimAnims(2)="Walk01"
     SwimAnims(3)="Walk01"
     CrouchAnims(0)="Walk01"
     CrouchAnims(1)="Walk01"
     CrouchAnims(2)="Walk01"
     CrouchAnims(3)="Walk01"
     WalkAnims(0)="Walk01"
     WalkAnims(1)="Walk01"
     WalkAnims(2)="Walk01"
     WalkAnims(3)="Walk01"
     AirAnims(0)="Walk01"
     AirAnims(1)="Walk01"
     AirAnims(2)="Walk01"
     AirAnims(3)="Walk01"
     TakeoffAnims(0)="Walk01"
     TakeoffAnims(1)="Walk01"
     TakeoffAnims(2)="Walk01"
     TakeoffAnims(3)="Walk01"
     LandAnims(0)="Walk01"
     LandAnims(1)="Walk01"
     LandAnims(2)="Walk01"
     LandAnims(3)="Walk01"
     DoubleJumpAnims(0)="Walk01"
     DoubleJumpAnims(1)="Walk01"
     DoubleJumpAnims(2)="Walk01"
     DoubleJumpAnims(3)="Walk01"
     DodgeAnims(0)="Walk01"
     DodgeAnims(1)="Walk01"
     DodgeAnims(2)="Walk01"
     DodgeAnims(3)="Walk01"
     AirStillAnim="Walk01"
     TakeoffStillAnim="Walk01"
     CrouchTurnRightAnim="Walk01"
     CrouchTurnLeftAnim="Walk01"
     IdleCrouchAnim="Idle_Alert"
     IdleSwimAnim="Idle_Alert"
     IdleWeaponAnim="Idle_Alert"
     IdleRestAnim="Idle_Alert"
     IdleChatAnim="Idle_Alert"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.FailedTransfer_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.FailedTransfer_skin02'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.FailedTransfer_skin01'
     Skins(2)=Texture'tk_Quake4Monstersv1.MonsterTextures.FailedTransfer_skin03'
     CollisionRadius=20.000000
     CollisionHeight=55.000000
}

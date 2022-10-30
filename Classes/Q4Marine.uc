class Q4Marine extends Quake4Monster config(Quake4Monsters);

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

function FireProjectile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('Muzzle');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
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
		Skins[2] = BurnFX;
		Skins[3] = BurnFX;
		bBurning = true;
	}

	Super.BurnAway();
}

defaultproperties
{
     ProjectileDamage=10
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee02"
     MeleeAnims(2)="Melee03"
     MeleeAnims(3)="Melee04"
     HitAnims(0)="Pain02"
     HitAnims(1)="Pain03"
     HitAnims(2)="Pain04"
     HitAnims(3)="Pain05"
     DeathAnims(0)="Pain01"
     DeathAnims(1)="Pain01"
     DeathAnims(2)="Pain01"
     DeathAnims(3)="Pain01"
     RangedAttackAnims(0)="RangedAttack04"
     RangedAttackAnims(1)="RangedAttack05"
     RangedAttackAnims(2)="RangedAttack06"
     RangedAttackAnims(3)="RangedAttack04"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Marine.growl1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Marine.growl2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Marine.growl3'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Marine.growl4'
     FootStepSounds(0)=Sound'PlayerSounds.BFootsteps.FootstepDefault1'
     FootStepSounds(1)=Sound'PlayerSounds.BFootsteps.FootstepDefault2'
     FootStepSounds(2)=Sound'PlayerSounds.BFootsteps.FootstepDefault3'
     FootStepSounds(3)=Sound'PlayerSounds.BFootsteps.FootstepDefault4'
     RangedAttackInterval=3.000000
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=10
     NewHealth=80
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Marine_Proj'
     HitSound(0)=Sound'tk_Quake4Monstersv1.Marine.pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Marine.pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Marine.pain3'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Marine.pain4'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Marine.die2'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Marine.die3'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Marine.die4'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Marine.die5'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Marine.chatter_idle3'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Marine.chatter_combat1'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Marine.chatter_combat2'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Marine.chatter_combat3'
     FireSound=Sound'tk_Quake4Monstersv1.Marine.fire02'
     ScoringValue=4
     WallDodgeAnims(0)="DodgeL02"
     WallDodgeAnims(1)="DodgeR02"
     WallDodgeAnims(2)="DodgeL02"
     WallDodgeAnims(3)="DodgeR02"
     IdleHeavyAnim="Idle02"
     IdleRifleAnim="Idle02"
     FireHeavyRapidAnim="Run"
     FireHeavyBurstAnim="Run"
     FireRifleRapidAnim="Run"
     FireRifleBurstAnim="Run"
     MeleeRange=60.000000
     GroundSpeed=500.000000
     Health=80
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
     AirAnims(0)="Leap"
     AirAnims(1)="Leap"
     AirAnims(2)="Leap"
     AirAnims(3)="Leap"
     TakeoffAnims(0)="Leap"
     TakeoffAnims(1)="Leap"
     TakeoffAnims(2)="Leap"
     TakeoffAnims(3)="Leap"
     LandAnims(0)="Leap"
     LandAnims(1)="Leap"
     LandAnims(2)="Leap"
     LandAnims(3)="Leap"
     DoubleJumpAnims(0)="Leap"
     DoubleJumpAnims(1)="Leap"
     DoubleJumpAnims(2)="Leap"
     DoubleJumpAnims(3)="Leap"
     DodgeAnims(0)="DodgeL02"
     DodgeAnims(1)="DodgeR02"
     DodgeAnims(2)="DodgeL02"
     DodgeAnims(3)="DodgeR02"
     AirStillAnim="Leap"
     TakeoffStillAnim="Leap"
     CrouchTurnRightAnim="Run"
     CrouchTurnLeftAnim="Run"
     IdleCrouchAnim="Idle02"
     IdleSwimAnim="Idle02"
     IdleWeaponAnim="Idle02"
     IdleRestAnim="Idle02"
     IdleChatAnim="Idle02"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Marine_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Marine_skin04'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.Marine_skin02'
     Skins(2)=Texture'tk_Quake4Monstersv1.MonsterTextures.Marine_skin03'
     Skins(3)=Texture'tk_Quake4Monstersv1.MonsterTextures.Marine_skin01'
     CollisionRadius=30.000000
     CollisionHeight=50.000000
}

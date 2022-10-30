class Q4StreamProtector extends Quake4Monster config(Quake4Monsters);

var() config int ProjectileDamage; //blasters 10
var() config int BigPlasmaDamage;
var() config int MissileDamage;
var() Name StreamProtectorAttacks[5];
var() config bool bMissileCanLock;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
		if(Q4StreamProtector_Proj(Other) != None)
		{
			Q4StreamProtector_Proj(Other).Damage = ProjectileDamage;
		}
		else if(Q4StreamProtector_Plasma(Other) != None)
		{
			Q4StreamProtector_Plasma(Other).Damage = BigPlasmaDamage;
		}
		else if(Q4StreamProtector_Missile(Other) != None)
		{
			Q4StreamProtector_Missile(Other).Damage = MissileDamage;
			Q4StreamProtector_Missile(Other).bMissileCanLock = bMissileCanLock;
			if(Target != None)
			{
				Q4StreamProtector_Missile(Other).Seeking = Target;
			}
		}
    }

    Super(Monster).GainedChild(Other);
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
		SetAnimAction(StreamProtectorAttacks[Rand(5)]);
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
		BoneLocation = GetBoneCoords('L_CG');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4StreamProtector_Proj',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,300));
		BoneLocation = GetBoneCoords('R_CG');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4StreamProtector_Proj',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,300));

		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

function FirePlasma()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('DM_muzzle');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4StreamProtector_Plasma',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,150));
		BoneLocation = GetBoneCoords('NG_muzzle');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4StreamProtector_Plasma',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,150));

		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Gladiator.railgun_blast',SLOT_Interact);
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

function FireMissileBottomLeft()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('missile_joint_4');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4StreamProtector_Missile',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,150));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Makron.bfg_fire',SLOT_Interact);
		}
	}
}

function FireMissileBottomRight()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('missile_joint_3');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4StreamProtector_Missile',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,150));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Makron.bfg_fire',SLOT_Interact);
		}
	}
}

function FireMissileTopLeft()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('missile_joint_2');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4StreamProtector_Missile',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,150));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Makron.bfg_fire',SLOT_Interact);
		}
	}
}

function FireMissileTopRight()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('missile_joint_1');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4StreamProtector_Missile',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,150));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Makron.bfg_fire',SLOT_Interact);
		}
	}
}

defaultproperties
{
     ProjectileDamage=15
     BigPlasmaDamage=25
     MissileDamage=100
     StreamProtectorAttacks(0)="RangedAttack01"
     StreamProtectorAttacks(1)="RangedAttack02"
     StreamProtectorAttacks(2)="RangedAttack03"
     StreamProtectorAttacks(3)="RangedAttack04"
     StreamProtectorAttacks(4)="Missiles"
     bMissileCanLock=True
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee02"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee02"
     HitAnims(0)="Pain01"
     HitAnims(1)="Pain02"
     HitAnims(2)="Pain03"
     HitAnims(3)="Pain02"
     DeathAnims(0)="Death01"
     DeathAnims(1)="Death02"
     DeathAnims(2)="Death03"
     DeathAnims(3)="Death01"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_growl'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_growl'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.StreamProtector.growl1'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.StreamProtector.growl1'
     FootStepSounds(0)=Sound'tk_Quake4Monstersv1.StreamProtector.step_1'
     FootStepSounds(1)=Sound'tk_Quake4Monstersv1.StreamProtector.step_2'
     FootStepSounds(2)=Sound'tk_Quake4Monstersv1.StreamProtector.step_3'
     FootStepSounds(3)=Sound'tk_Quake4Monstersv1.StreamProtector.step_4'
     RangedAttackInterval=4.000000
     bCanBeTeleFrag=False
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=30
     NewHealth=1000
     bHasDeathAnim=True
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4StreamProtector_Proj'
     bCanDodge=False
     HitSound(0)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_pain1'
     HitSound(1)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_pain2'
     HitSound(2)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_pain1'
     HitSound(3)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_pain2'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_death'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_death'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_death'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_death'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_alert'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.StreamProtector.chatter1'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.StreamProtector.chatter2'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.StreamProtector.stream_alert'
     FireSound=Sound'tk_Quake4Monstersv1.grunt.Blaster01'
     ScoringValue=25
     WallDodgeAnims(0)="WalkF"
     WallDodgeAnims(1)="WalkF"
     WallDodgeAnims(2)="WalkF"
     WallDodgeAnims(3)="WalkF"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="WalkF"
     FireHeavyBurstAnim="WalkF"
     FireRifleRapidAnim="WalkF"
     FireRifleBurstAnim="WalkF"
     bCanJump=False
     MeleeRange=150.000000
     GroundSpeed=380.000000
     Health=1000
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
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.StreamProtector_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.StreamProtector_skin01'
     CollisionRadius=70.000000
     CollisionHeight=80.000000
}

class Q4Voss extends Quake4Monster config(Quake4Monsters);

var() Q4Voss_Head BossHeadActor;
var() config int DarkMatterDamage;
var() config bool bMissileCanLock;
var() config int MissileDamage;
var() config bool bCanSummon;
var() config int SummonLimit;
var() config string MonsterToSummon[3];
var() config int ShieldHealth;
var() config float ArmourDamageModifier; //damage is multiplied by this number on armour
var() config float SpawnIntervalTime;
var() float LastSpawnTime;

event GainedChild(Actor Other)
{
    if(bUseDamageConfig)
    {
        if(Q4Voss_Missile(Other) != None)
        {
            Q4Voss_Missile(Other).Damage = MissileDamage;
            Q4Voss_Missile(Other).bMissileCanLock = bMissileCanLock;
            if(Target != None)
            {
				Q4Voss_Missile(Other).Seeking = Target;
			}
        }
        else if(Q4Voss_DarkMatter(Other) != None)
        {
			Q4Voss_DarkMatter(Other).Damage = DarkMatterDamage;
		}
    }

    Super(Monster).GainedChild(Other);
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if(Level.NetMode != NM_DedicatedServer)
    {
		if(BossHeadActor == None)
		{
			BossHeadActor = Spawn(class'Q4Voss_Head',self);
			if(BossHeadActor != None)
			{
				AttachToBone(BossHeadActor,'bosshead');
				UpdateVossHead();
			}
		}
	}
}

simulated function UpdateVossHead()
{
	if(BossHeadActor != None)
	{
		BossHeadActor.AmbientGlow = AmbientGlow;
		BossHeadActor.SetDrawScale(DrawScale);
		BossHeadActor.SetDrawScale3D(DrawScale3D);
		BossHeadActor.bHidden = bHidden;
	}
}

simulated function SetOverlayMaterial( Material mat, float time, bool bOverride )
{
	if(BossHeadActor != None)
	{
		BossHeadActor.SetOverlayMaterial(mat, time, bOverride );
	}

	Super.SetOverlayMaterial(mat, time, bOverride );
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
	else if(bCanSummon && NumSpawn < SummonLimit && Level.TimeSeconds - LastSpawnTime > SpawnIntervalTime)
	{
		SpawnSphere();
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastSpawnTime = Level.TimeSeconds;
	}
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

function FireProjectile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;

	if ( Controller != None )
	{
		BoneLocation = GetBoneCoords('dmg_muzzle');
		FireStart = BoneLocation.Origin;
		Proj = Spawn(ProjectileClass,self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,70));
		if(Proj != None)
		{
			PlaySound(FireSound,SLOT_Interact);
		}
	}
}

function FireMissile()
{
	local Vector FireStart;
	local Coords BoneLocation;
	local Projectile Proj;
	local Name RocketBones[2];

	if ( Controller != None )
	{
		RocketBones[0] = 'rocket_muzzle1';
		RocketBones[1] = 'rocket_muzzle2';
		BoneLocation = GetBoneCoords(RocketBones[Rand(2)]);
		FireStart = BoneLocation.Origin;
		Proj = Spawn(class'Q4Voss_Missile',self,,FireStart,Controller.AdjustAim(SavedFireProperties,FireStart,150));
		if(Proj != None)
		{
			PlaySound(Sound'tk_Quake4Monstersv1.Makron.bfg_fire',SLOT_Interact);
		}
	}
}

simulated function BurnAway()
{
	if(bUseBurnAwayEffect && BurnFX != None)
	{
		Skins[0] = BurnFX;
		//Skins[1] = InvisMat;
		bBurning = true;
		if(BossHeadActor != None)
		{
			BossHeadActor.BurnFX = BurnFX;
			BossHeadActor.BurnAway();
		}
	}

	Super.BurnAway();
	UpdateVossHead();
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    local int actualDamage;
    local Controller Killer;
    local name HitBone;
    local float Dist;

    if ( damagetype == None )
    {
        if ( InstigatedBy != None )
            warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
        DamageType = class'DamageType';
    }

    if ( Role < ROLE_Authority )
    {
        log(self$" client damage type "$damageType$" by "$instigatedBy);
        return;
    }

    if ( Health <= 0 )
        return;

    if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
        instigatedBy = DelayedDamageInstigatorController.Pawn;

    if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
        SetMovementPhysics();
    if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
        momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
    if ( instigatedBy == self )
        momentum *= 0.6;
    momentum = momentum/Mass;

    if (Weapon != None)
        Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if (DrivenVehicle != None)
            DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
        Damage *= 2;
    actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
    if( DamageType.default.bArmorStops && (actualDamage > 0) )
        actualDamage = ShieldAbsorb(actualDamage);

    CalcHitLoc( hitlocation, vect(0,0,0), HitBone, Dist);

    actualDamage = GetFinalDamage(HitBone,actualDamage,instigatedBy, hitlocation, momentum, damageType);

    Health -= actualDamage;
    if ( HitLocation == vect(0,0,0) )
        HitLocation = Location;

    if ( Health <= 0 )
    {
        // pawn died
        if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
            Killer = LastHitBy;
        else if ( instigatedBy != None )
            Killer = instigatedBy.GetKillerController();
        if ( Killer == None && DamageType.Default.bDelayedDamage )
            Killer = DelayedDamageInstigatorController;
        if ( bPhysicsAnimUpdate )
            TearOffMomentum = momentum;
        Died(Killer, damageType, HitLocation);
    }
    else
    {
        AddVelocity( momentum );
        if ( Controller != None )
            Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
        if ( instigatedBy != None && instigatedBy != self )
            LastHitBy = instigatedBy.Controller;
    }
    MakeNoise(1.0);
}

/*function DamageShield(int Dmg)
{
	ShieldHealth -= Dmg;
	if(ShieldHealth <= 0)
	{
		SetAnimAction(RangedAttackAnims[Rand(4)]);
		Controller.bPreparingMove = true;
		Acceleration = vect(0,0,0);
		LastRangedAttack = Level.TimeSeconds;
		bShotAnim = true;
	}
}

simulated function ShieldDown()
{
	Skins[1] = InvisMat;

	if(Level.NetMode != NM_DedicatedServer)
	{
		Spawn(class'Q4Voss_ShieldExplode',self,,GetBoneCoords('neckcontrol').Origin);
	}

	if(Role == Role_Authority)
	{
		PlaySound(Sound'XEffects.Effects.FlakExplosionSnd',SLOT_Interact);
	}
}*/
//damage is modified if hits armour (roughly)
function int GetFinalDamage(name HitBone, int Dmg, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if(HitBone == 'dmg01' || HitBone == 'dmg02' || HitBone == 'dmg03' || HitBone == 'dmg04')
	{
		/*if(ShieldHealth > 0)
		{
			DamageShield(Dmg);
			return 0;
		}*/

		PlayHit(Dmg,InstigatedBy, hitLocation, damageType, Momentum);
		return Dmg;
	}

	Dmg = Dmg * ArmourDamageModifier;
	return Dmg;
}

defaultproperties
{
     DarkMatterDamage=25
     bMissileCanLock=True
     MissileDamage=35
     bCanSummon=True
     SummonLimit=4
     MonsterToSummon(0)="tk_Quake4Monstersv1.Q4Grunt"
     MonsterToSummon(1)="tk_Quake4Monstersv1.Q4Marine"
     MonsterToSummon(2)="tk_Quake4Monstersv1.Q4Marine"
     ArmourDamageModifier=0.250000
     SpawnIntervalTime=7.000000
     MeleeAnims(0)="Melee01"
     MeleeAnims(1)="Melee02"
     MeleeAnims(2)="Melee01"
     MeleeAnims(3)="Melee02"
     HitAnims(0)="Pain01"
     HitAnims(1)="Pain01"
     HitAnims(2)="Pain01"
     HitAnims(3)="Pain01"
     DeathAnims(0)="Pain02"
     DeathAnims(1)="Pain02"
     DeathAnims(2)="Pain02"
     DeathAnims(3)="Pain02"
     RangedAttackAnims(0)="RangedAttack01"
     RangedAttackAnims(1)="RangedAttack02"
     RangedAttackAnims(2)="RangedAttack03"
     RangedAttackAnims(3)="RangedAttack01"
     MeleeAttackSounds(0)=Sound'tk_Quake4Monstersv1.Marine.growl1'
     MeleeAttackSounds(1)=Sound'tk_Quake4Monstersv1.Marine.growl2'
     MeleeAttackSounds(2)=Sound'tk_Quake4Monstersv1.Marine.growl3'
     MeleeAttackSounds(3)=Sound'tk_Quake4Monstersv1.Marine.growl4'
     FootStepSounds(0)=Sound'PlayerSounds.BFootsteps.FootstepDefault1'
     FootStepSounds(1)=Sound'PlayerSounds.BFootsteps.FootstepDefault2'
     FootStepSounds(2)=Sound'PlayerSounds.BFootsteps.FootstepDefault3'
     FootStepSounds(3)=Sound'PlayerSounds.BFootsteps.FootstepDefault4'
     RangedAttackInterval=3.000000
     bCanBeTeleFrag=False
     bUseDamageConfig=True
     bUseHealthConfig=True
     MeleeDamage=50
     NewHealth=1500
     ProjectileClass=Class'tk_Quake4Monstersv1.Q4Voss_DarkMatter'
     bCanDodge=False
     HitSound(0)=Sound'tk_Quake4Monstersv1.Voss.Pain01'
     HitSound(1)=Sound'tk_Quake4Monstersv1.Voss.Pain02'
     HitSound(2)=Sound'tk_Quake4Monstersv1.Voss.Pain03'
     HitSound(3)=Sound'tk_Quake4Monstersv1.Voss.Pain04'
     DeathSound(0)=Sound'tk_Quake4Monstersv1.Voss.Death01'
     DeathSound(1)=Sound'tk_Quake4Monstersv1.Voss.Death02'
     DeathSound(2)=Sound'tk_Quake4Monstersv1.Voss.Death03'
     DeathSound(3)=Sound'tk_Quake4Monstersv1.Voss.Death01'
     ChallengeSound(0)=Sound'tk_Quake4Monstersv1.Marine.chatter_idle3'
     ChallengeSound(1)=Sound'tk_Quake4Monstersv1.Marine.chatter_combat1'
     ChallengeSound(2)=Sound'tk_Quake4Monstersv1.Marine.chatter_combat2'
     ChallengeSound(3)=Sound'tk_Quake4Monstersv1.Marine.chatter_combat3'
     FireSound=Sound'tk_Quake4Monstersv1.Marine.fire02'
     ScoringValue=25
     WallDodgeAnims(0)="Walk"
     WallDodgeAnims(1)="Walk"
     WallDodgeAnims(2)="Walk"
     WallDodgeAnims(3)="Walk"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     bCanJump=False
     MeleeRange=80.000000
     GroundSpeed=500.000000
     Health=1500
     MovementAnims(0)="Walk"
     MovementAnims(1)="Walk"
     MovementAnims(2)="Walk"
     MovementAnims(3)="Walk"
     TurnLeftAnim="Walk"
     TurnRightAnim="Walk"
     SwimAnims(0)="Walk"
     SwimAnims(1)="Walk"
     SwimAnims(2)="Walk"
     SwimAnims(3)="Walk"
     CrouchAnims(0)="Walk"
     CrouchAnims(1)="Walk"
     CrouchAnims(2)="Walk"
     CrouchAnims(3)="Walk"
     WalkAnims(0)="Walk"
     WalkAnims(1)="Walk"
     WalkAnims(2)="Walk"
     WalkAnims(3)="Walk"
     AirAnims(0)="Walk"
     AirAnims(1)="Walk"
     AirAnims(2)="Walk"
     AirAnims(3)="Walk"
     TakeoffAnims(0)="Walk"
     TakeoffAnims(1)="Walk"
     TakeoffAnims(2)="Walk"
     TakeoffAnims(3)="Walk"
     LandAnims(0)="Walk"
     LandAnims(1)="Walk"
     LandAnims(2)="Walk"
     LandAnims(3)="Walk"
     DoubleJumpAnims(0)="Walk"
     DoubleJumpAnims(1)="Walk"
     DoubleJumpAnims(2)="Walk"
     DoubleJumpAnims(3)="Walk"
     DodgeAnims(0)="Walk"
     DodgeAnims(1)="Walk"
     DodgeAnims(2)="Walk"
     DodgeAnims(3)="Walk"
     AirStillAnim="Walk"
     TakeoffStillAnim="Walk"
     CrouchTurnRightAnim="Walk"
     CrouchTurnLeftAnim="Walk"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.Voss_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Voss_skin01'
     CollisionRadius=60.000000
     CollisionHeight=70.000000
}

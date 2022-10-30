class Q4Scientist_Proj extends Grenade placeable;

var() Emitter NewTrail;
var() int GasDamagePerSecond;
var() Sound ExplosionSound[2];

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer)
    {
        NewTrail = Spawn(class'Q4Scientist_Proj_Trail', self);
        NewTrail.SetBase(self);
    }

    if ( Role == ROLE_Authority )
    {
        Velocity = Speed * Vector(Rotation);
        RandSpin(25000);
        bCanHitOwner = false;
        if (Instigator.HeadVolume.bWaterVolume)
        {
            bHitWater = true;
            Velocity = 0.6*Velocity;
        }
    }
}

simulated function Destroyed()
{
	if ( NewTrail != None )
	{
		NewTrail.Kill();
	}

    Super(Projectile).Destroyed();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);
    PlaySound(ExplosionSound[Rand(2)],,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'Q4Scientist_Proj_Explode',,, HitLocation, rotator(vect(0,0,1)));
        Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }
    Destroy();
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector dir;
    local Q4Scientist_Gas Gas;

    Gas = Spawn(class'Q4Scientist_Gas',Owner,,Location);
    if(Gas != None)
    {
		Gas.GasDamagePerSecond = GasDamagePerSecond;
		if(Pawn(Owner) != None)
		{
			Gas.PawnOwner = Pawn(Owner);
		}
	}

    if ( bHurtEntry )
        return;

    bHurtEntry = true;
    foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
    {
        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
        {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
            if ( Instigator == None || Instigator.Controller == None )
                Victims.SetDelayedDamageInstigatorController( InstigatorController );
            if ( Victims == LastTouched )
                LastTouched = None;
            Victims.TakeDamage
            (
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
                (damageScale * Momentum * dir),
                DamageType
            );
            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

        }
    }
    if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') )
    {
        Victims = LastTouched;
        LastTouched = None;
        dir = Victims.Location - HitLocation;
        dist = FMax(1,VSize(dir));
        dir = dir/dist;
        damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
        if ( Instigator == None || Instigator.Controller == None )
            Victims.SetDelayedDamageInstigatorController(InstigatorController);
        Victims.TakeDamage
        (
            damageScale * DamageAmount,
            Instigator,
            Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
            (damageScale * Momentum * dir),
            DamageType
        );
        if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
    }

    bHurtEntry = false;
}

defaultproperties
{
     GasDamagePerSecond=5
     ExplosionSound(0)=Sound'tk_Quake4Monstersv1.Scientist.chemical_burst1'
     ExplosionSound(1)=Sound'tk_Quake4Monstersv1.Scientist.chemical_burst2'
     Speed=700.000000
     MaxSpeed=1000.000000
     TossZ=470.000000
     Damage=10.000000
     MyDamageType=Class'tk_Quake4Monstersv1.DamType_Q4Scientist'
     DrawScale=5.000000
}

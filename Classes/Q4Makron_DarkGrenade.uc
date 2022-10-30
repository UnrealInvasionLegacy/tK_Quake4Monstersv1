class Q4Makron_DarkGrenade extends Grenade placeable;

var() Emitter NewTrail;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer)
    {
        NewTrail = Spawn(class'Q4Makron_DarkGrenadeFX', self);
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
    PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'Q4Makron_DarkGrenade_Explode',,, HitLocation, rotator(vect(0,0,1)));
        Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }
    Destroy();
}

defaultproperties
{
     Speed=350.000000
     MaxSpeed=500.000000
     TossZ=450.000000
     Damage=60.000000
     MyDamageType=Class'tk_Quake4Monstersv1.DamType_Q4Makron'
     AmbientSound=Sound'tk_Quake4Monstersv1.Makron.grenade_fly'
     DrawScale=5.000000
     SoundVolume=255
     SoundRadius=100.000000
}

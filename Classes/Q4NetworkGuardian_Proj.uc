class Q4NetworkGuardian_Proj extends Quake4Projectile placeable;

var() bool bMissileCanLock;

replication
{
    reliable if(Role==ROLE_Authority)
    	bMissileCanLock;
}

simulated function PostBeginPlay()
{
    local Rotator R;

    Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer && TrailClass != None )
    {
        Trail = Spawn(TrailClass, self);
        Trail.SetBase(self);
    }

    Velocity = Vector(Rotation) * Speed;
    R = Rotation;
    R.Roll = 32768;
    SetRotation(R);

    if(bSeeking)
    {
        SetTimer(0.4,true);
    }
}

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;

    if ( InitialDir == vect(0,0,0) )
    {
        InitialDir = Normal(Velocity);
    }

    Acceleration = vect(0,0,0);
    Super.Timer();
    if( Seeking != None && bMissileCanLock)
    {
        ForceDir = Normal(Seeking.Location + vect(0,0,20) - Location);

        VelMag = 1.02 * VSize(Velocity);

        ForceDir = Normal(ForceDir * 1.1 * VelMag + Velocity);
        Velocity = VelMag * ForceDir;
        SetRotation(rotator(Velocity));
        SetTimer(0.1,true);
    }
    else
    {
        Velocity = Vector(Rotation);
        Velocity *= Speed;
        SetTimer(0.0, false);
    }
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
    if ( (Other != instigator) && Q4NetworkGuardian_Proj(Other) == None && (!Other.IsA('Projectile') || Other.bProjTarget) )
    {
        Explode(HitLocation, vect(0,0,1));
    }
}

defaultproperties
{
     bMissileCanLock=True
     TrailClass=Class'tk_Quake4Monstersv1.Q4NetworkGuardian_Proj_Trail'
     ExplosionClass=Class'tk_Quake4Monstersv1.Q4NetworkGuardian_Proj_Explode'
     bSeeking=True
     Speed=700.000000
     MaxSpeed=800.000000
     Damage=10.000000
     MyDamageType=Class'tk_Quake4Monstersv1.DamType_Q4NetworkGuardian'
     ImpactSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
     DrawScale=0.500000
     DrawScale3D=(X=3.000000)
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     DesiredRotation=(Roll=30000)
}

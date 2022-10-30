class Q4Voss_Missile extends Quake4Projectile placeable;

var() bool bMissileCanLock;
var() float LockTime;
var() float LockCounter;

replication
{
    reliable if(Role==ROLE_Authority)
    	bMissileCanLock;
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
        LockCounter += 0.1;
        if(LockCounter > LockTime)
        {
			bMissileCanLock = false;
		}
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
    if ( (Other != instigator) && Q4StreamProtector_Missile(Other) == None && (!Other.IsA('Projectile') || Other.bProjTarget) )
    {
        Explode(HitLocation, vect(0,0,1));
    }
}

defaultproperties
{
     bMissileCanLock=True
     LockTime=1.800000
     TrailClass=Class'tk_Quake4Monstersv1.Q4Voss_Missile_Trail'
     ExplosionClass=Class'tk_Quake4Monstersv1.Q4Voss_Missile_Explode'
     bSeeking=True
     Speed=600.000000
     MaxSpeed=1200.000000
     Damage=35.000000
     MyDamageType=Class'tk_Quake4Monstersv1.DamType_Q4Voss'
     ImpactSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'tk_Quake4Monstersv1.Smeshes.Q4_RocketProj_Model'
     DrawScale3D=(X=-2.000000,Y=1.500000,Z=1.500000)
     Skins(0)=Texture'Shiptech.Floors.flr06bCS'
     bProjTarget=True
     bFixedRotationDir=True
     RotationRate=(Roll=80000)
     DesiredRotation=(Roll=30000)
}

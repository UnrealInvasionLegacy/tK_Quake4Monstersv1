class Q4Sentry_Proj extends Quake4Projectile;

simulated function Destroyed()
{
    if(Trail !=None)
    {
		if(TrailEmitter(Trail.Emitters[1]) != None)
		{
			TrailEmitter(Trail.Emitters[1]).Disabled = true;
		}
	}

    Super.Destroyed();
}

defaultproperties
{
     TrailClass=Class'tk_Quake4Monstersv1.Q4Sentry_Proj_Trail'
     ExplosionClass=Class'tk_Quake4Monstersv1.Q4Sentry_Proj_Explode'
     Speed=1500.000000
     MaxSpeed=2000.000000
     Damage=8.000000
     MyDamageType=Class'tk_Quake4Monstersv1.DamType_Q4Sentry'
}

class Q4IronMaiden_Proj extends Quake4Projectile placeable;

defaultproperties
{
     TrailClass=Class'tk_Quake4Monstersv1.Q4IronMaiden_Proj_Trail'
     ExplosionClass=Class'tk_Quake4Monstersv1.Q4IronMaiden_Proj_Explode'
     Speed=1400.000000
     MaxSpeed=1500.000000
     Damage=10.000000
     MyDamageType=Class'tk_Quake4Monstersv1.DamType_Q4IronMaiden'
     ImpactSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.RocketProj'
     DrawScale=0.500000
     bFixedRotationDir=True
     DesiredRotation=(Roll=30000)
}

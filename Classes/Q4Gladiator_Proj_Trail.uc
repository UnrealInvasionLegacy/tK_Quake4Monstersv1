class Q4Gladiator_Proj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=30.000000
         UseCrossedSheets=True
         PointLifeTime=1.000000
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScaleRepeats=-1.000000
         ColorMultiplierRange=(Y=(Min=0.700000,Max=0.700000),Z=(Min=0.250000,Max=0.250000))
         Opacity=0.600000
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=10.000000)
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=15.000000,Max=5.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Beams.HotBolt04aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=500.000000,Max=500.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_Quake4Monstersv1.Q4Gladiator_Proj_Trail.TrailEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=167,G=217,R=254))
         ColorScale(1)=(RelativeTime=1.000000)
         Opacity=0.200000
         MaxParticles=150
         RevolutionsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=14.000000,Max=15.000000))
         ParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Energy.SmoothRing'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=1.000000)
         InitialDelayRange=(Min=0.050000,Max=0.050000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4Gladiator_Proj_Trail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         UniformSize=True
         ColorScale(0)=(Color=(B=128,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=255,R=255))
         ColorMultiplierRange=(Y=(Min=0.800000,Max=0.800000),Z=(Min=0.800000,Max=0.800000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartSizeRange=(X=(Min=30.000000,Max=30.000000))
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         WarmupTicksPerSecond=10.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(2)=SpriteEmitter'tk_Quake4Monstersv1.Q4Gladiator_Proj_Trail.SpriteEmitter1'

}

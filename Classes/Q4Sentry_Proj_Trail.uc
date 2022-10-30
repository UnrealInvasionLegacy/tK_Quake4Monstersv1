class Q4Sentry_Proj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'XEffects.BlueMarker_t'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4Sentry_Proj_Trail.SpriteEmitter0'

     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=8.000000
         PointLifeTime=0.300000
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.500000,Max=0.500000))
         MaxParticles=1
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Beams.HotBolt04aw'
         LifetimeRange=(Min=999.000000,Max=999.000000)
     End Object
     Emitters(1)=TrailEmitter'tk_Quake4Monstersv1.Q4Sentry_Proj_Trail.TrailEmitter0'

}

class Q4StreamProtector_Proj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.300000,Max=0.300000),Z=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSizeRange=(X=(Min=4.000000,Max=4.000000))
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4StreamProtector_Proj_Trail.SpriteEmitter3'

     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=8.000000
         PointLifeTime=0.050000
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.200000,Max=0.200000))
         MaxParticles=1
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Beams.HotBolt04aw'
         LifetimeRange=(Min=999.000000,Max=999.000000)
     End Object
     Emitters(1)=TrailEmitter'tk_Quake4Monstersv1.Q4StreamProtector_Proj_Trail.TrailEmitter0'

}

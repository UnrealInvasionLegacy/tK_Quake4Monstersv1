class Q4Grunt_Proj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_PointLife
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=80.000000
         PointLifeTime=0.800000
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScaleRepeats=-1.000000
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.400000,Max=0.500000))
         Opacity=0.600000
         MaxParticles=1
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=15.000000,Max=5.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Beams.BeamFalloff'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=500.000000,Max=500.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_Quake4Monstersv1.Q4Grunt_Proj_Trail.TrailEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         ProjectionNormal=(X=1.000000,Z=0.000000)
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.600000,Max=0.200000))
         Opacity=0.400000
         MaxParticles=50
         RevolutionsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'AW-2004Particles.Weapons.SmokePanels1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.400000,Max=0.200000)
         InitialDelayRange=(Min=0.050000,Max=0.050000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4Grunt_Proj_Trail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=192,G=128,R=128))
         ColorScale(1)=(RelativeTime=1.000000)
         Opacity=0.500000
         MaxParticles=25
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=0.000000,Max=10.000000))
         Texture=Texture'AW-2004Particles.Energy.AirBlast'
         LifetimeRange=(Min=0.100000,Max=0.200000)
     End Object
     Emitters(2)=SpriteEmitter'tk_Quake4Monstersv1.Q4Grunt_Proj_Trail.SpriteEmitter1'

}

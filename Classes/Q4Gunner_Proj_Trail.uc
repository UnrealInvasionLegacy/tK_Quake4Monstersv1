class Q4Gunner_Proj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter2
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=8.000000
         PointLifeTime=0.300000
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScaleRepeats=-1.000000
         ColorMultiplierRange=(X=(Min=0.400000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         Opacity=0.700000
         MaxParticles=1
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Beams.BeamFalloff'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=999.000000,Max=999.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_Quake4Monstersv1.Q4Gunner_Proj_Trail.TrailEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         ProjectionNormal=(X=1.000000,Z=0.000000)
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(X=(Min=0.600000,Max=0.200000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.200000,Max=0.800000))
         Opacity=0.400000
         MaxParticles=50
         RevolutionsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=2.000000)
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
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4Gunner_Proj_Trail.SpriteEmitter2'

}

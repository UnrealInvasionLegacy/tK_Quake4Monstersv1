class Q4StreamProtector_Plasma_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter1
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         UseCrossedSheets=True
         PointLifeTime=0.500000
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScaleRepeats=-1.000000
         ColorMultiplierRange=(Y=(Min=0.200000,Max=0.500000),Z=(Max=0.500000))
         MaxParticles=1
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'EpicParticles.Beams.BeamFalloff'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=9999.000000,Max=9999.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_Quake4Monstersv1.Q4StreamProtector_Plasma_Trail.TrailEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         ProjectionNormal=(X=1.000000,Z=0.000000)
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.200000,Max=0.500000),Z=(Min=0.200000,Max=0.500000))
         MaxParticles=50
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=10.000000)
         RevolutionsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=4.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=2.000000,Max=5.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.400000,Max=0.200000)
         InitialDelayRange=(Min=0.050000,Max=0.050000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4StreamProtector_Plasma_Trail.SpriteEmitter5'

}

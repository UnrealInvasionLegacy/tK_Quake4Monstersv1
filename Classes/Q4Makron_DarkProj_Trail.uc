class Q4Makron_DarkProj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         ProjectionNormal=(X=1.000000,Z=0.000000)
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,R=64))
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=2.000000)
         RevolutionsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=3.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=8.000000,Max=10.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'tk_Quake4Monstersv1.MonsterTextures.darkmatteradd'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.200000,Max=0.100000)
         InitialDelayRange=(Min=0.050000,Max=0.050000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4Makron_DarkProj_Trail.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Max=0.700000),Y=(Min=0.700000,Max=0.500000))
         Opacity=0.400000
         CoordinateSystem=PTCS_Relative
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=10.000000,Max=12.000000))
         Texture=Texture'tk_Quake4Monstersv1.MonsterTextures.railgun_ring_end'
         LifetimeRange=(Min=0.300000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4Makron_DarkProj_Trail.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Max=0.800000),Y=(Max=0.700000))
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=25.000000,Max=10.000000))
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=1.000000,Max=0.700000)
     End Object
     Emitters(2)=SpriteEmitter'tk_Quake4Monstersv1.Q4Makron_DarkProj_Trail.SpriteEmitter6'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.700000
         CoordinateSystem=PTCS_Relative
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=20.000000,Max=30.000000))
         ParticlesPerSecond=10.000000
         DrawStyle=PTDS_Darken
         Texture=Texture'EpicParticles.Smoke.Maelstrom01aw'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(3)=SpriteEmitter'tk_Quake4Monstersv1.Q4Makron_DarkProj_Trail.SpriteEmitter7'

}

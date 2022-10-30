class Q4Dropper_Proj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(X=(Min=0.900000,Max=0.700000),Z=(Max=1.200000))
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=50
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Fire.AuraSpray'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.200000,Max=0.300000)
         InitialDelayRange=(Min=0.050000,Max=0.050000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4Dropper_Proj_Trail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         Disabled=True
         Backup_Disabled=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Max=0.800000),Z=(Min=0.800000))
         Opacity=0.800000
         MaxParticles=3
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=25.000000,Max=20.000000))
         Texture=Texture'AW-2004Particles.Energy.BurnFlare'
         LifetimeRange=(Min=0.100000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4Dropper_Proj_Trail.SpriteEmitter1'

}

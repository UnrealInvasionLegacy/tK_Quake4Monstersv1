class Q4Scientist_Proj_Explode extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         BlendBetweenSubdivisions=True
         ColorMultiplierRange=(X=(Min=0.300000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         Opacity=0.300000
         FadeInEndTime=0.500000
         MaxParticles=50
         StartLocationRange=(X=(Min=-75.000000,Max=75.000000),Y=(Min=-75.000000,Max=75.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=24.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=60.000000,Max=80.000000),Y=(Min=60.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'ExplosionTex.Framed.exp1_frames'
         TextureUSubdivisions=2
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=5.000000,Max=7.000000)
         StartVelocityRange=(Z=(Max=10.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4Scientist_Proj_Explode.SpriteEmitter1'

}

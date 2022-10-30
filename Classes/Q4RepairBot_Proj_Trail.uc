class Q4RepairBot_Proj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_Linear
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         UseCrossedSheets=True
         PointLifeTime=0.200000
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.250000,Max=0.250000))
         MaxParticles=3
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=6.000000,Max=6.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Energy.AngryBeam'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=999.000000,Max=999.000000)
     End Object
     Emitters(0)=TrailEmitter'tk_Quake4Monstersv1.Q4RepairBot_Proj_Trail.TrailEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         ProjectionNormal=(X=1.000000,Z=0.000000)
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.500000),Z=(Min=0.250000,Max=0.250000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         RevolutionsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.100000,Max=0.100000)
         InitialDelayRange=(Min=0.050000,Max=0.050000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4RepairBot_Proj_Trail.SpriteEmitter2'

}

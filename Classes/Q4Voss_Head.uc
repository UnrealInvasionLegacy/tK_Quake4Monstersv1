class Q4Voss_Head extends Actor placeable;

var() QuakeBurnTex BurnFX;
var() Material InvisMat;
var() bool bBurning;
var() int BurnSpeed;

event BaseChange()
{
	if(Base == None)
	{
		Destroy();
	}
}

simulated function BurnAway()
{
	if(BurnFX != None)
	{
		Skins[0] = BurnFX;
		Skins[1] = InvisMat;
		bBurning = true;
	}
	else
	{
		SetDrawType(DT_None);
	}
}

simulated function Tick(float deltatime)
{
	local int i;

	SetRelativeLocation(vect(0.2,1.75,0.8));
	SetRelativeRotation(rot(0,-7500,16500));

	if(bBurning)
	{
		if(BurnFX != None)
		{
			if(BurnFX.AlphaRef != 255)
			{
				BurnFX.AlphaRef += BurnSpeed;
			}
			else
			{
				for(i=0;i<Skins.Length;i++)
				{
					Skins[i] = InvisMat;
					bHidden = true;
				}

				Disable('Tick');
			}
		}
	}
}

defaultproperties
{
     InvisMat=Shader'tk_Quake4Monstersv1.MonsterTextures.InvisMat'
     BurnSpeed=1
     DrawType=DT_Mesh
     bAlwaysRelevant=True
     Mesh=SkeletalMesh'tk_Quake4Monstersv1.VossHead_mesh'
     DrawScale=1.500000
     Skins(0)=Texture'tk_Quake4Monstersv1.MonsterTextures.Voss_skin02'
     Skins(1)=Texture'tk_Quake4Monstersv1.MonsterTextures.FailedTransfer_skin01'
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bCollideActors=True
}

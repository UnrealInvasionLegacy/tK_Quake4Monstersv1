class Q4Scientist_Gas extends Actor;

var() int GasDamagePerSecond;
var() Pawn PawnOwner;

function PostBeginPlay()
{
	SetTimer(0.5,true);
}

function Timer()
{
	local Pawn P;
	local float Damage;

	Damage = GasDamagePerSecond/2;

	foreach RadiusActors(class'Pawn', P, 150)
	{
		if(AllowedToDamage(P))
		{
			P.TakeDamage(int(Damage), P, P.Location, vect(1000,0,0), class'DamType_Q4Scientist');
		}
	}
}

function bool AllowedToDamage(Pawn P)
{
	//if Pawn is not equal to none and it has health left
	if(P != None && P.Health > 0)
	{
		//only checking for player/monster pawns
		if(P.Controller != None)
		{
			//if its a friendly monster i.e rpg or other mods which use it then no
			if(P.Controller.IsA('FriendlyMonsterController'))
			{
				return true;
			}
			else if(P.Controller.IsA('MonsterController')) //don't hurt other types of monsters
			{
				return false;
			}
			else
			{
				//damage all others ie players/bots
				return true;
			}
		}
	}

	//fallback to true
	return true;
}

defaultproperties
{
     GasDamagePerSecond=5
     DrawType=DT_None
     LifeSpan=5.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bCollideActors=True
}

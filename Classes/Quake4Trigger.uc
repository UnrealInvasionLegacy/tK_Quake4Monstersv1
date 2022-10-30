class Quake4Trigger extends Trigger;

var() class<Quake4Monster> MonsterToSpawn;

function Touch( actor Other )
{
    local int i;

    if( IsRelevant( Other ) )
    {
        Other = FindInstigator( Other );

        if ( ReTriggerDelay > 0 )
        {
            if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
                return;
            TriggerTime = Level.TimeSeconds;
        }
        // Broadcast the Trigger message to all matching actors.

        TriggerEvent(Event, self, Other.Instigator);

        if ( (Pawn(Other) != None) && (Pawn(Other).Controller != None) )
        {
            for ( i=0;i<4;i++ )
                if ( Pawn(Other).Controller.GoalList[i] == self )
                {
                    Pawn(Other).Controller.GoalList[i] = None;
                    break;
                }
        }

        if( (Message != "") && (Other.Instigator != None) )
            // Send a string message to the toucher.
            Other.Instigator.ClientMessage( Message );

        if( bTriggerOnceOnly )
            // Ignore future touches.
            SetCollision(False);
        else if ( RepeatTriggerTime > 0 )
            SetTimer(RepeatTriggerTime, false);
    }
}

simulated function TriggerEvent (Name EventName, Actor Other, Pawn EventInstigator)
{
	local NavigationPoint N;

	if(EventInstigator.IsA('Monster'))
	{
		return;
	}

	EventInstigator.Controller.PlayerReplicationInfo.Score -= 10;

	for (N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint)
	{
		if(N.Tag == 'MonsterSpawn')
		{
			Spawn(MonsterToSpawn,,,N.Location + vect(0,0,150),);
			break;
		}
	}

	Super.TriggerEvent(EventName,Other,EventInstigator);
}

defaultproperties
{
     RepeatTriggerTime=1.000000
}

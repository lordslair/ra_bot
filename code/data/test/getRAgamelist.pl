#!/usr/bin/perl
use strict;
use warnings;

use JSON;

use lib '/code/lib';
use RAB::RAAPI;

my $recent_gamelist = RAB::RAAPI::GetUserRecentlyPlayedGames($ARGV[0]);

if ($recent_gamelist)
{
    my $JSON = decode_json($recent_gamelist);
    my %X;
    my @csv;

    my $max = scalar @{$JSON}; # Because I'm not sure I'll receive 10 last played games
    for (my $i = 0; $i < $max; $i++) # And we loop
    {
        push @csv, $JSON->[$i]->{GameID};
        $X{$JSON->[$i]->{GameID}} = $i;
    }

    my $Progress_ref = RAB::RAAPI::GetUserProgress($ARGV[0],\@csv);
    my %Progress     = %{$Progress_ref};

    print "Game ID | SC Ach. | SC Score  | HC Ach. | HC Score \n";
    print "=======   =======   =========   =======   =========\n";
    foreach my $game_id ( sort keys %Progress )
    {
        my $PossibleScore           = $Progress{$game_id}{'PossibleScore'};
        my $NumAchieved             = $Progress{$game_id}{'NumAchieved'};
        my $NumPossibleAchievements = $Progress{$game_id}{'NumPossibleAchievements'};
        my $ScoreAchieved           = $Progress{$game_id}{'ScoreAchieved'};
        my $ScoreAchievedHardcore   = $Progress{$game_id}{'ScoreAchievedHardcore'};
        my $NumAchievedHardcore     = $Progress{$game_id}{'NumAchievedHardcore'};
        printf "%-7d | %3d/%3d | %4d/%4d | %3d/%3d | %4d/%4d\n",
               $game_id,
               $NumAchieved,           $NumPossibleAchievements,
               $ScoreAchieved,         $PossibleScore,
               $NumAchievedHardcore,   $NumPossibleAchievements,
               $ScoreAchievedHardcore, $PossibleScore;
    }
}

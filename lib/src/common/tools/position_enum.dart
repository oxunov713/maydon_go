enum FootballPosition {
  centerForward('Center Forward', 'CF'),
  leftWingForward('Left Wing Forward', 'LWF'),
  rightWingForward('Right Wing Forward', 'RWF'),
  centerMidfielder('Center Midfielder', 'CMF1'),
  centerMidfielder2('Center Midfielder', 'CMF2'),
  defensiveMidfielder('Defensive Midfielder', 'DMF'),
  leftBack('Left Back', 'LB'),
  rightBack('Right Back', 'RB'),
  centerBack('Center Back', 'CB1'),
  centerBack2('Center Back', 'CB2'),
  goalkeeper('Goalkeeper', 'GK');

  final String fullName;
  final String abbreviation;

  const FootballPosition(this.fullName, this.abbreviation);
}

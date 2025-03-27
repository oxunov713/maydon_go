enum FootballPosition {
  goalkeeper('Goalkeeper', 'GK'),
  centerForward('Center Forward', 'CF'),
  leftWingForward('Left Wing Forward', 'LWF'),
  rightWingForward('Right Wing Forward', 'RWF'),
  centerMidfielder('Center Midfielder', 'CMF'),
  centerMidfielder2('Center Midfielder', 'CMF'),
  defensiveMidfielder('Defensive Midfielder', 'DMF'),
  leftBack('Left Back', 'LB'),
  rightBack('Right Back', 'RB'),
  centerBack('Center Back', 'CB'),
  centerBack2('Center Back', 'CB');

  final String fullName;
  final String abbreviation;

  const FootballPosition(this.fullName, this.abbreviation);
}

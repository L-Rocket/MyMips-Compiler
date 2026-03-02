def MyMipsModel : SchedMachineModel {
  let MicroOpBufferSize = 0;
  let IssueWidth = 1;
  let LoadLatency = 1;
  let MispredictPenalty = 10;
}

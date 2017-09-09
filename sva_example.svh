/***********************************************************
* Description                                              *
* Examples of how to use sva for spcified requirements     *
***********************************************************/
// clock definition
// diable iff rst

/*
*A signal stay high for a period
*/
property stay_high(signal, period);
  $rose(signal) |-> signal[*period] ##1 !signal
endproperty

sva_stay_high: assert property(stay_high(end_frame_o, 5));

/*
* A signal rise after a period of another signal fell/rise
*/
property rise_after_period(sig_i, sig_exp, period);
  $fell(sig_i) |-> ##period $rise(sig_exp)
endproperty

sva_rise_after_period: assert property(stay_high(end_frame_o, 5));

/*
* A signal rise after a period of another signal rise
*/
property prp_rise_after_period(sig_i, sig_exp, period);
  $rise(sig_i) |-> ##period $rise(sig_exp)
endproperty

/*
* A signal only rise once between a period.
* Don't care about the width of its high peirod
*/ 
sequence seq_window_period(sig_from, sig_to);
  $fell(sig_from) ##[*1:$] $rise(sig_to);
endsequence

property prp_rise_once_between_window_period(sig_exp, sig_i);
  $rise(sig_exp) |-> ##[*1:$] !$rise(sig_exp) throughout seq_window_period(sig_from, sig_to);
endproperty

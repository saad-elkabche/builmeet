


String rateCalculator(double rates,int nbRates){
  double rate;
  if(nbRates==0){
    rate= 0;
  }else{
    rate=(rates/nbRates);
  }
  return rate.toStringAsFixed(1);
}
#pragma Opencl EXTENSION cl_khr_fp64: enable
__kernel void get_pvalue(__global int *xx, __global double *xy, __global double *xw, __global double *yw, __global double *wwi, const double yy, const int q0, const int row, __global double *p_value, __global double *B21, __global double *NeginvB22B21, __global double *B21B21, __global double *ixx, __global double *rhs, __global double *beta, __global double *t_value){
	int i, j, k;
	int q1 = (q0+1)*(q0+1);
	int df = row-q0-1;
	double t, invB22, t2, ve, diag_ixx, se;
	int id = get_global_id(0);
	int idx = id * row;
	int idc = id * q0;
	int idcs = id * q0 *q0;
	int idp = id * (q0+1);
	int idps = id * q1;
    
	for (i = 0; i < q0; i++) {
		B21[idc+i] = 0;
		for (j = 0; j < q0; j++) {
			B21[idc+i] += xw[idc+j] * wwi[i*q0 + j];
		}
	}
	for (t = 0, i = 0; i < q0; i++) {
		t += B21[idc+i] * xw[idc+i];
	}
	invB22 = 1/(xx[id] - t);
	for (i = 0; i < q0; i++) {
		NeginvB22B21[idc+i] = (-invB22) * B21[idc+i];
	}
	for (i = 0; i < q0; i++) {
		for (j = 0; j < q0; j++) {
			B21B21[idcs+i*q0+j] = B21[idc+i]*B21[idc+j]*invB22;
		}
	}
	for (i = 0; i < q0; i++) {
		for (j = 0; j < q0; j++) {
			ixx[idps+i*(q0+1)+j] = wwi[i*q0+j] + B21B21[idcs+i*q0+j];
		}
	}
	for (i = 0; i < q0; i++) {
        ixx[idps+(i+1)*q0+i] = NeginvB22B21[idc+i];
    }
	for (i = 0; i < q0; i++) {
		ixx[idps+q0*(q0+1)+i] = NeginvB22B21[idc+i];
	}
	ixx[idps+q1-1] = invB22;
	for (i = 0; i < q0; i++) {
		rhs[idp+i] = yw[i];
	}
	rhs[idp+q0] = xy[id];
	for (i = 0; i < q0+1; i++) {
		beta[idp+i] = 0;
		for (j = 0; j < q0+1; j++) {
			beta[idp+i] += ixx[idps+i+j*(q0+1)] * rhs[idp+j];
		}
	}
	for (t2=0, i = 0; i < q0+1; i++) {
		t2 += beta[idp+i]*rhs[idp+i];
	}
	ve = (yy - t2) / df;
	diag_ixx = ixx[idps+q0*(q0+1)+q0];
	se = sqrt(diag_ixx * ve);
	t_value[id] = beta[idp+q0] / se;
    
	/* get p_value */
	double a = 0.5*df, b = 0.5, x = df/(df + t_value[id] * t_value[id]);
	double bt;
	double a1 = a, b1 = b, x1 = x;
	int m,m2;
	double aa,c,d,del,h,qab,qam,qap,betacf1,betacf2;
	qab=a1+b1;
	qap=a1+1.0;
	qam=a1-1.0;
	c=1.0;
	d=1.0-qab*x1/qap;
	if (fabs(d) < 1.0e-30)
		d=1.0e-30;
	d=1.0/d;
	h=d;
	for (m=1;m<=100;m++) {
		m2=2*m;
		aa=m*(b1-m)*x1/((qam+m2)*(a1+m2));
		d=1.0+aa*d; 
		if (fabs(d) < 1.0e-30) d=1.0e-30;
		c=1.0+aa/c;
		if (fabs(c) < 1.0e-30) c=1.0e-30;
		d=1.0/d;
		h *= d*c;
		aa = -(a1+m)*(qab+m)*x1/((a1+m2)*(qap+m2));
		d=1.0+aa*d; 
		if (fabs(d) < 1.0e-30) d=1.0e-30;
		c=1.0+aa/c;
		if (fabs(c) < 1.0e-30) c=1.0e-30;
		d=1.0/d;
		del=d*c;
		h *= del;
		if (fabs(del-1.0) < 3.0e-7) break; 
	}
	betacf1 = h;
	
	double a2 = b, b2 = a, x2 = 1.0-x;
	qab=a2+b2;
	qap=a2+1.0;
	qam=a2-1.0;
	c=1.0;
	d=1.0-qab*x2/qap;
	if (fabs(d) < 1.0e-30)
		d=1.0e-30;
	d=1.0/d;
	h=d;
	for (m=1;m<=100;m++) {
		m2=2*m;
		aa=m*(b2-m)*x2/((qam+m2)*(a2+m2));
		d=1.0+aa*d; 
		if (fabs(d) < 1.0e-30) d=1.0e-30;
		c=1.0+aa/c;
		if (fabs(c) < 1.0e-30) c=1.0e-30;
		d=1.0/d;
		h *= d*c;
		aa = -(a2+m)*(qab+m)*x2/((a2+m2)*(qap+m2));
		d=1.0+aa*d; 
		if (fabs(d) < 1.0e-30) d=1.0e-30;
		c=1.0+aa/c;
		if (fabs(c) < 1.0e-30) c=1.0e-30;
		d=1.0/d;
		del=d*c;
		h *= del;
		if (fabs(del-1.0) < 3.0e-7) break; 
	}
	betacf2 = h;
    
	double gammln_ab, gammln_a, gammln_b;
	double tmpx,tmpy,tmp,ser;
	double cof[6]={76.18009172947146,-86.50532032941677,24.01409824083091,-1.231739572450155,0.1208650973866179e-2,-0.5395239384953e-5};
	//int j;
	tmpy=tmpx=a+b;
	tmp=tmpx+5.5;
	tmp -= (tmpx+0.5)*log(tmp);
	ser=1.000000000190015;
	for (j=0;j<=5;j++) ser += cof[j]/++tmpy;
	gammln_ab= -tmp+log(2.5066282746310005*ser/tmpx);
	
	tmpy=tmpx=a;
	tmp=tmpx+5.5;
	tmp -= (tmpx+0.5)*log(tmp);
	ser=1.000000000190015;
	for (j=0;j<=5;j++) ser += cof[j]/++tmpy;
	gammln_a= -tmp+log(2.5066282746310005*ser/tmpx);
	
	tmpy=tmpx=b;
	tmp=tmpx+5.5;
	tmp -= (tmpx+0.5)*log(tmp);
	ser=1.000000000190015;
	for (j=0;j<=5;j++) ser += cof[j]/++tmpy;
	gammln_b= -tmp+log(2.5066282746310005*ser/tmpx);
    
	if (x == 0.0 || x == 1.0)
		bt=0.0;
	else 
		bt=exp(gammln_ab-gammln_a-gammln_b+a*log(x)+b*log(1.0-x));
	if (x < (a+1.0)/(a+b+2.0)) 
		p_value[id] = bt*betacf1/a;
	else 
        p_value[id] = 1.0-bt*betacf2/b; 
}
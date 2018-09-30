__kernel void get_xw_xy(__global unsigned long int *a1, __global unsigned long int *a0, __global int *genotype, __global double *y, __global double *w, const int n_row, const int q0, const int row, __global double *xw, __global double *xy){
	int id = get_global_id(0);
	int idx = id * row, idxw = id * q0;
	
	int i=0, j=0, temp1=0, temp2=0;
        temp1 = id*n_row;
        for (j=0; j<n_row-1; j++) {
				temp2 = 64*j;
            for (i=63; i > -1; i--) {
                genotype[idx+temp2+i] = (a1[temp1+j] & 1)*2 + (a0[temp1+j] & 1);
                a1[temp1+j] >>= 1;
                a0[temp1+j] >>= 1;
            }
        }
			j = n_row-1;
			temp2 = 64*j;
        if ((row/64 * 64) == row){
            for (i=63; i > -1; i--) {
                genotype[idx+temp2+i] = (a1[temp1+j] & 1)*2 + (a0[temp1+j] & 1);
                a1[temp1+j] >>= 1;
                a0[temp1+j] >>= 1;
            }
        }
        else {
            for (i=row-64*j-1; i > -1; i--) {
                genotype[idx+temp2+i] = (a1[temp1+j] & 1)*2 + (a0[temp1+j] & 1);
                a1[temp1+j] >>= 1;
                a0[temp1+j] >>= 1;
            }
        }
    
			xy[id]=0;
        for (i = 0; i < row; i++) {	
            xy[id] += (double)genotype[idx+i]*y[i];
        }
        for (i = 0; i < q0; i++) {
				xw[idxw+i]=0;
            for (j = 0; j < row; j++) {
                xw[idxw+i] += (double)genotype[idx+j] * w[i*row + j];
            }
        }
}
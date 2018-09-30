int popCount(unsigned long int i)
{
	i = i - ((i >> 1) & 0x5555555555555555);
	i = (i & 0x3333333333333333) + ((i >> 2) & 0x3333333333333333);
	i = (i + (i >> 4)) & 0x0f0f0f0f0f0f0f0f;
	i = i + (i >> 8);
	i = i + (i >> 16);
	i = i + (i >> 32);
	return (int)i & 0x7f;
}

__kernel void get_xw(__global unsigned long int *a1, __global unsigned long int *a0, __global unsigned long int *w1, __global unsigned long int *w0, const int n_row, const int q0, __global int *xw){
	int id = get_global_id(0);
	int idx = id * n_row, idxw = id * q0;
	
	int i, j, temp;
	for (i = 0; i < q0; i++) {
		xw[idxw+i] = 0;
		temp = n_row*i;
		for (j = 0; j < n_row; j++) {
            xw[idxw+i] += popCount(a1[idx+j] & w1[temp+j])*4 + popCount((a1[idx+j] ^ w1[temp+j]) & (a0[idx+j] ^ w0[temp+j]))*2 + popCount(a0[idx+j] & w0[temp+j]);
		}
	}
}

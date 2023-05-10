int sum(int n){
	int i,s=0;
	for(i = 0; i <= n; ++i){
		s += i;
	}
	return s;
}

int main() {
	int x = 100;
	int y;
	y = sum(x);
	return 0;
}
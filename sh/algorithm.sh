    public void dfs(int[] counts,int index, ArrayList<Integer> a){
        for(int i=0;i<counts[index];i++){
            a.set(index, i);
            if(index == counts.length-1){//到最后一个循环控制变量k了
//                ArrayList<Integer> b = new ArrayList<Integer>(a);
                System.out.println(a.toString());
            }
            else{
                dfs(counts,index+1, a);
            }
        }
    }

cout 总层数，index 当前层数,cache 当前层数的排列组合，end最终排列组合
    public ArrayList<ArrayList<Integer>> test(int index, int count, ArrayList<ArrayList<Integer>> cache, ArrayList<ArrayList<Integer>> end) {
        if (index == 0) {
            cache = new ArrayList<>();
            for (int i=0;i<4; i++) {
                ArrayList<Integer> temp = new ArrayList<>();
                temp.add(i);
                Collections.sort(temp);
                cache.add(temp);
            }
            return test(++index, count, cache, end);
        }
        end = new ArrayList<>();
//        ArrayList<ArrayList<Integer>>
        for(int j=0; j < cache.size(); j++) {
            for (int i=0;i<4; i++) {
                ArrayList<Integer> temp = (ArrayList<Integer>) cache.get(j).clone();
                temp.add(i);
                Collections.sort(temp);
                end.add(temp);
            }
        }
        ++index;
        if (index == count) {
            return end;
        }
        return test(index, count, end, end);

//        for (int i=cache.get(index); i<=4; i++) {
//            // 设置当前层的i的值
//            cache.set(index, i);
//            // 如果层数是最后一层
//            if (index == count) {
//                arr.add(cache);
//            }
//
//            // 如果遍历完毕
//            if (cache.get(0) == 4) {
//                return arr;
//            }
//            if (index == count) {
//
//            }
//            // 如果没有到最后一层
//            else {
//                Integer next = index + 1;
//                return test(next, count, cache, arr);
//            }
//        }
//        return null;
        // 返回上一层
//        return test(index -1, count, cache, arr);
//        Integer next = index + 1;
//        return test(next, count, cache, arr);
    }

    public ArrayList<Integer> getArr(Integer n) {
        ArrayList<Integer> a = new ArrayList<>();
        for (Integer i=0; i< n; i++) {
            a.add(1);
        }
        return a;
    }
	
	
	        // n 层for
        Integer n = 4;
//        int[] counts = {3,3,3,3};
        int[] counts = {3,3,3,3};
//        int[] a = {0,0,0};
        ArrayList<Integer> a = new ArrayList<>();
        a.add(0);
        a.add(0);
        a.add(0);
        a.add(0);

        dfs(counts, 0, a);


//        ArrayList<Integer> cache = getArr(n);
        ArrayList<ArrayList<Integer>> arr = new ArrayList<>();
        arr = test(0, n, null, null);
        ArrayList<String> t = new ArrayList<>();
        for(int j=0; j < arr.size(); j++) {
           t.add(arr.get(j).toString());
        }
        t = ParamUtil.duplicateRemove(t);

		
		
		
		}
		
快速排序法
取第一个元素作为关键值
尾部找一个比他小的，替换i，首部找一个比他大的，替换j处的空缺，不断替换空缺，碰到指针一致，则在该处填入关键值


微服务：
注册中心：
Spring Cloud Eureka：服务发现，注册服务信息、心跳交互
Netflix Zuul：api网关，类似nginx，将代理api请求
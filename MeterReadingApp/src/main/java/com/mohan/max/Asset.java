package com.mohan.max;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Asset {
	@SuppressWarnings("unchecked")
	public static void main(String[] args) {
		
		
//		Map<String, List<String>[]> ls = new LinkedHashMap<>();
//		ArrayList<String> arr[] = new ArrayList[3];
//		
//		arr[0].add("123khtfkjh");
//		arr[1].add("khtfkjh");
//		arr[2].add("khtfkjh");
//		for(int i =0;i<arr.length;i++) {
//			System.out.println(arr[i]);
//		}
//		for(int i=0;i<arr.length;i++) {
//			ls.put("gfd"+i, arr);
//		}
//		System.out.println(ls);
//		
		
        List<Integer> list[]=null;
        for(int x=0; x<2; x++){ 
            list[x]= new ArrayList<>();
            for(int j=0;j<10;j++) {
            	list[x].add(j);
            	
        }
        
        }
        for(int i=0;i<list.length;i++) {
        	System.out.println(list[i]);
        }
		
//		String arr[]= {};
//		arr = MeterQueries.addLabel(arr, "Hello");
//		arr = MeterQueries.addLabel(arr, "Hello");
//		arr = MeterQueries.addLabel(arr, "Hello");
//		arr = MeterQueries.addLabel(arr, "Hello");
//		for(String s : arr)
//			System.out.println(s);
	}
}

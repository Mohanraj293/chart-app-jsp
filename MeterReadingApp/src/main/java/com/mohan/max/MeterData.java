package com.mohan.max;

import java.util.ArrayList;
import java.util.List;

public class MeterData {
	private List measurePoint = new ArrayList<>();
	private List meter = new ArrayList<>();
	private List warnings = new ArrayList<>();
	public List getMeasurePoint() {
		return measurePoint;
	}
	public void setMeasurePoint(List measurePoint) {
		this.measurePoint = measurePoint;
	}
	public List getMeter() {
		return meter;
	}
	public void setMeter(List meter) {
		this.meter = meter;
	}
	public List getWarnings() {
		return warnings;
	}
	public void setWarnings(List warnings) {
		this.warnings = warnings;
	}

}

/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.ibm.watson.developer_cloud.alchemy.v1.model;

import java.util.List;

import com.google.gson.annotations.SerializedName;
import com.ibm.watson.developer_cloud.alchemy.v1.AlchemyDataNews;
import com.ibm.watson.developer_cloud.service.model.GenericModel;

/**
 * VolumeResult by the {@link AlchemyDataNews#getVolume(String, String, String)} service.
 *
 * @author Nizar Alseddeg (nmalsedd@us.ibm.com)
 */
public class VolumeResult extends AlchemyGenericModel {

	/**
	 * The Class Volume.
	 */
	public static class Volume extends GenericModel {

	    /** The count. */
	    private Integer count;

	    /** The slices. */
	    private List<Integer> slices;


	    /**
	     * Gets the count.
	     *
	     * @return The count
	     */
	    public int getCount() {
	        return count;
	    }

	    /**
	     * Gets the slices.
	     *
	     * @return The slices
	     */
	    public List<Integer> getSlices() {
	        return slices;
	    }

	    /**
	     * Sets the count.
	     *
	     * @param count The count
	     */
	    public void setCount(int count) {
	        this.count = count;
	    }

	    /**
	     * Sets the slices.
	     *
	     * @param slices The slices
	     */
	    public void setSlices(List<Integer> slices) {
	        this.slices = slices;
	    }

	}
	
    /** The volume. */
    @SerializedName("result")
    private Volume volume;

    /**
	 * Gets the volume.
	 *
	 * @return the volume
	 */
	public Volume getVolume() {
		return volume;
	}

	/**
	 * Sets the volume.
	 *
	 * @param volume the volume to set
	 */
	public void setVolume(Volume volume) {
		this.volume = volume;
	}

}

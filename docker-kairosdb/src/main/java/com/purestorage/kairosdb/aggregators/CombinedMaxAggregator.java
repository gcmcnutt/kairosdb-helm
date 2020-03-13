/*
 * Copyright 2016 KairosDB Authors
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
package com.purestorage.kairosdb.aggregators;

import com.google.inject.Inject;
import com.purestorage.kairosdb.datapoints.CombinedDataPoint;
import com.purestorage.kairosdb.datapoints.CombinedDataPointFactory;
import org.kairosdb.core.DataPoint;
import org.kairosdb.core.aggregator.RangeAggregator;
import org.kairosdb.core.annotation.FeatureComponent;

import java.util.Collections;
import java.util.Iterator;

/**
 * Converts combined data into averages.
 */
@FeatureComponent(
        name = "max",
        label = "MAX",
        description = "Find the maximum of each combined elements."
)
public class CombinedMaxAggregator extends RangeAggregator {
    CombinedDataPointFactory m_dataPointFactory;

    // TODO we may need a QueryCompoundProperty here: https://kairosdb.github.io/docs/build/html/kairosdevelopment/Aggregators_and_GroupBys.html


    @Inject
    public CombinedMaxAggregator(CombinedDataPointFactory dataPointFactory) {
        m_dataPointFactory = dataPointFactory;
    }

    @Override
    protected RangeSubAggregator getSubAggregator() {
        return (new CombinedMaxDataPointAggregator());
    }

    @Override
    public boolean canAggregate(String groupType) {
        return CombinedDataPointFactory.GROUP_TYPE.equals(groupType);
    }

    @Override
    public String getAggregatedGroupType(String groupType) {
        return m_dataPointFactory.getGroupType();
    }

    private class CombinedMaxDataPointAggregator implements RangeSubAggregator {

        @Override
        public Iterable<DataPoint> getNextDataPoints(long returnTime, Iterator<DataPoint> dataPointRange) {
            double max_br = Double.NEGATIVE_INFINITY;
            double max_bw = Double.NEGATIVE_INFINITY;
            double max_ir = Double.NEGATIVE_INFINITY;
            double max_iw = Double.NEGATIVE_INFINITY;
            double max_lr = Double.NEGATIVE_INFINITY;
            double max_lw = Double.NEGATIVE_INFINITY;
            while (dataPointRange.hasNext()) {
                CombinedDataPoint dp = (CombinedDataPoint) dataPointRange.next();
                max_br = Double.max(max_br, dp.getBr());
                max_bw = Double.max(max_bw, dp.getBw());
                max_ir = Double.max(max_ir, dp.getIr());
                max_iw = Double.max(max_iw, dp.getIw());
                max_lr = Double.max(max_lr, dp.getLr());
                max_lw = Double.max(max_lw, dp.getLw());
            }

            return Collections.singletonList(m_dataPointFactory.createDataPoint(returnTime,
                    max_br, max_bw, max_ir, max_iw, max_lr, max_lw));
        }
    }
}
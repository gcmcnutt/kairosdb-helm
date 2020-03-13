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
        name = "avg",
        label = "AVG",
        description = "Averages the combined data points together."
)
public class CombinedAvgAggregator extends RangeAggregator {
    CombinedDataPointFactory m_dataPointFactory;

    // TODO we may need a QueryCompoundProperty here: https://kairosdb.github.io/docs/build/html/kairosdevelopment/Aggregators_and_GroupBys.html


    @Inject
    public CombinedAvgAggregator(CombinedDataPointFactory dataPointFactory) {
        m_dataPointFactory = dataPointFactory;
    }

    @Override
    protected RangeSubAggregator getSubAggregator() {
        return (new CombinedAvgDataPointAggregator());
    }

    @Override
    public boolean canAggregate(String groupType) {
        return CombinedDataPointFactory.GROUP_TYPE.equals(groupType);
    }

    @Override
    public String getAggregatedGroupType(String groupType) {
        return m_dataPointFactory.getGroupType();
    }

    private class CombinedAvgDataPointAggregator implements RangeSubAggregator {

        @Override
        public Iterable<DataPoint> getNextDataPoints(long returnTime, Iterator<DataPoint> dataPointRange) {
            int count = 0;
            double sum_br = 0;
            double sum_bw = 0;
            double sum_ir = 0;
            double sum_iw = 0;
            double sum_lr = 0;
            double sum_lw = 0;
            while (dataPointRange.hasNext()) {
                CombinedDataPoint dp = (CombinedDataPoint) dataPointRange.next();
                count++;
                sum_br += dp.getBr();
                sum_bw += dp.getBw();
                sum_ir += dp.getIr();
                sum_iw += dp.getIw();
                sum_lr += dp.getLr();
                sum_lw += dp.getLw();
            }

            return Collections.singletonList(m_dataPointFactory.createDataPoint(returnTime,
                    sum_br / count,
                    sum_bw / count,
                    sum_ir / count,
                    sum_iw / count,
                    sum_lr / count,
                    sum_lw / count));
        }
    }
}
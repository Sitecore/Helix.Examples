import React from 'react';
import { Meta } from '@storybook/react/types-6-0';
import HeroBanner, { HeroBannerProps } from './HeroBanner';

export default {
    title: 'Components/HeroBanner',
    component: HeroBanner
} as Meta;

export const WithImage: React.VFC<{}> = () => {
    const props : HeroBannerProps = {
        fields: {
            Title: {
                value: "Lorem ipsum dolor sit"
            },
            Subtitle: {
                value: "Aenean pharetra leo"
            },
            Image: {
                value: {
                    src: "https://placekitten.com/1920/510"
                }
            }
        }
    };
    return <HeroBanner {...props} />;
};
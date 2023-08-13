import { AppProps } from 'next/app';
import dynamic from 'next/dynamic';

import { API_MOCKING } from '@/config/constants';
import { MSWWrapperProps } from '@/lib/msw';

const MSWWrapper = dynamic<MSWWrapperProps>(() =>
  import('@/lib/msw').then(({ MSWWrapper }) => MSWWrapper)
);

const App = ({ Component, pageProps }: AppProps) => {
  const pageContent = <Component {...pageProps} />;
  return (
    <>
      { API_MOCKING ? (
        <MSWWrapper>{ pageContent }</MSWWrapper>
      ) : (
        pageContent
      )}
    </>
  );
}

export default App;

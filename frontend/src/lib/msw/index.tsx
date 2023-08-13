import { ReactNode } from 'react';
import { setupWorker } from 'msw';
import { setupServer } from 'msw/node';
import { IS_SERVER, IS_BROWSER } from '@/config/constants';
import { handlers } from '@/lib/msw/handlers';

const initializeMocks = () => {
  if (IS_SERVER) {
    const server = setupServer(...handlers);
    server.listen();
  } else if (IS_BROWSER) {
    const worker = setupWorker(...handlers);
    worker.start();
  }
};
initializeMocks();

export type MSWWrapperProps = {
  children: ReactNode;
};

export const MSWWrapper = ({
  children,
}: MSWWrapperProps) => {
  return (
    <>
      { children }
    </>
  );
};
